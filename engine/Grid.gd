extends TileMap

onready var Enemy_instance = preload("res://actors/Enemy.tscn")
onready var Ally_instance = preload("res://actors/Ally.tscn")
onready var Syringe = preload("res://items/Syringe.tscn")

# grid elements
onready var Player = $Player
onready var Enemy = $Enemy
onready var Ally = $Ally
onready var Selection_Grid: TileMap = $"../SelectionGrid"
var rooms = []
var enemies = []
var allies = []
var objects = []
var items = []

# game variables
var floor_n = -1
var n_enemies = 10
var n_objects = 10
var n_items = 10
var was_blocked: bool = false
var last_selected_pos: Vector2 = Vector2(-1, -1)
var last_selected_tile: int

# turn queue
var actors = [null]
var current_index = 0

func _ready() -> void:
	set_physics_process(false)
	randomize()
	var _err = events.connect("new_game", self, "_on_new_game")
	_err = events.connect("turn_started", Enemy, "_on_Grid_turn_started")
	_err = events.connect("turn_started", Ally, "_on_Grid_turn_started")
	_err = events.connect("turn_started", Player, "_on_Grid_turn_started")
	_err = events.connect("game_over", Player, "_on_game_over")
	
	_err = events.connect("level_loaded", Player, "_on_Grid_level_loaded")
	_err = events.connect("level_loaded", self, "_on_Grid_level_loaded")
	
	_err = events.connect("entity_removed", self, "_on_Grid_entity_removed")
	_err = events.connect("item_spawned", self, "spawn_item")
	_err = events.connect("ally_spawned", self, "spawn_ally")
	_err = events.connect("calc_targets", self, "calc_and_highlight_targets")
	_err = events.connect("area_effect", self, "_on_area_effect")

func _on_Grid_level_loaded() -> void:
	set_physics_process(true)

func _on_new_game() -> void:
	events.emit_signal("new_message", tr("GAME_START"))
	Player.manual_init()
	for enemy in enemies:
		enemy.manual_init()
	for ally in allies:
		ally.manual_init()
#	for object in objects:
#		object.manual_init()
#	for item in items:
#		item.manual_init()

func init(grid_rooms: Array) -> void:
	rooms = grid_rooms
	clean_up()
	spawn_player()
	spawn_items()
	spawn_enemies()
	events.emit_signal("new_message", tr("LEVEL_ENTERED"), color.grey)
	events.emit_signal("level_loaded")

func clean_up() -> void:
	actors = [null]
	current_index = 0
	for enemy in enemies:
		enemy.remove()
	for object in objects:
		object.remove()
	for item in items:
		item.remove()
	data.entities = []

func spawn_player() -> void:
	var pos = get_available_position()
	if pos != null:
		Player.position = pos
	Player.cursor_pos = pos
	actors[0] = Player
	data.entities.append(Player)

func spawn_ally(type: int, pos: Vector2) -> void:
	var ally_spawned = Ally_instance.instance()
	ally_spawned.position = pos
	spawn_actor(ally_spawned, type, false)

func spawn_actor(actor: Actor, type: int, get_pos: bool = false) -> void:
	if actor.name == 'Enemy':
		enemies.append(actor)
		actor.add_to_group("enemies")
	if actor.name == 'Ally':
		allies.append(actor)
		actor.add_to_group("allies")
	actors.append(actor)
	add_child(actor)
	actor.add_type(type)
	if get_pos:
		actor.position = get_available_position()
	data.entities.append(actor)
	actor.manual_init()

func spawn_enemies() -> void:
	for _i in range(n_enemies):
		var enemy = Enemy_instance.instance()
		spawn_actor(enemy, randi() % 4, true)

func round_to_tile(pos: Vector2) -> Vector2:
	return map_to_world(world_to_map(pos))

func spawn_item(item: Item, get_pos: bool = false) -> void:
	items.append(item)
	add_child(item)
	if get_pos:
		item.position = get_available_position()
	else:
		item.position = round_to_tile(get_local_mouse_position())
	data.entities.append(item)

func spawn_items() -> void:
	for _i in range(n_items):
		var item = Syringe.instance()
		item.add_type(en.SYRINGE_TYPE.values()[randi() % 4])
		spawn_item(item, true)

func _on_Grid_entity_removed(node: Node) -> void:
	items.erase(node)
	node.queue_free()

func get_available_position():
	var pos: Vector2
	pos = get_room_and_pos()
	while true:
		if is_pos_available(pos):
			return pos
		else:
			pos = get_room_and_pos()

func get_room_and_pos() -> Vector2:
	var chosen_room = rooms[randi() % rooms.size()]
	var room_top_left = chosen_room.position
	var room_bottom_right = chosen_room.end
	var pos = map_to_world(Vector2(int(rand_range(room_top_left.x, room_bottom_right.x - 1)),
		int(rand_range(room_top_left.y, room_bottom_right.y - 1))))
	return pos

func is_pos_available(pos: Vector2) -> bool:
	for e in data.entities:
		if e.position == pos:
			return false
	return true

func is_actor_in_position(pos: Vector2):
	for a in actors:
		if a.position == pos:
			return a
	return false

# debugging function
#func _draw() -> void:
#	for room in rooms:
#		draw_rect(Rect2(map_to_world(room.position), map_to_world(room.size)), Color.from_hsv(rand_range(0, 6), 1, 1), true)

func _on_area_effect(targets: PoolVector2Array, effect: Dictionary) -> void:
	var entity 
	for target in targets:
		entity = data.is_entity_in_position(target)
		if entity != null:
			if actors.has(entity):
				if effect.has("damage"):
					entity.take_damage(effect.damage)
				#additional effects here
	
func calc_and_highlight_targets(center_tile: Vector2, tile_range: int, overlay: bool):
	var possible_targets = data.calc_area(center_tile, tile_range)
	var size = possible_targets.size() - 1
	for i in range(size, -1, -1):
		var pos = possible_targets[i]
		if get_cellv(world_to_map(pos)) == -1:
			if overlay or !data.is_entity_in_position(pos):
				Selection_Grid.set_cellv(world_to_map(pos), en.TARGET_TILES.SELECTABLE)
		else:
			possible_targets.remove(i)
	events.emit_signal("targets_calculated", possible_targets)

func look(pos: Vector2, tile: int, is_first: bool = false) -> void:
	var found = false
	if !is_first:
		Selection_Grid.set_cellv(world_to_map(last_selected_pos), last_selected_tile)
	last_selected_pos = pos
	last_selected_tile = Selection_Grid.get_cellv(world_to_map(pos))
	for entity in data.entities:
		if pos == entity.position:
			Selection_Grid.set_cellv(world_to_map(pos), tile)
			found = true
			if tile == en.TARGET_TILES.LOOK:
				events.emit_signal("look_at_entity", entity)
			break
	if !found:
		Selection_Grid.set_cellv(world_to_map(pos), tile)
		if tile == en.TARGET_TILES.LOOK:
			events.emit_signal("look_at_entity", null)

func interact(child_node: Actor) -> bool:
	var turn_completed = true
	if child_node.direction == Vector2():
		return turn_completed
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if is_inside_bounds(grid_pos):
		if get_cellv(grid_pos) == -1:
			var blocked = false
			var to_remove = []
			# enemies
			if enemies.size() != 0:
				for i in range(enemies.size() - 1, -1, -1):
					var enemy = enemies[i]
					if grid_pos == world_to_map(enemy.position):
						child_node.basic_attack(enemy)
						blocked = true
						break
			# allies
			for ally in allies:
				if grid_pos == world_to_map(ally.position):
					ally.direction = child_node.direction
					if !passive_interact(ally):
						blocked = true
						turn_completed = false
					else:
						events.emit_signal("new_message", tr("PLAYER_PUSH"),
						color.cyan, [ally.entity_name])
					break
			# objects
			for object in objects:
				if grid_pos == world_to_map(object.position):
					if object.can_interact:
						object.interact()
						events.emit_signal("new_message", object.interaction,
							color.white, object.args)
					else:
						turn_completed = false
						events.emit_signal("new_message", tr("BLOCKED"))
					blocked = true
					break
			# items
			if !blocked:
				for item in items:
					if grid_pos == world_to_map(item.position):
						if item.pick_up(child_node):
							events.emit_signal("new_message", tr("ITEM_PICK"), 
								color.white, [item.entity_name])
							to_remove.append(item)
						else:
							events.emit_signal("new_message", tr("INV_FULL"),
								color.white, [item.entity_name])
						break
			for o in to_remove:
				o.remove()
			# movement
			if !blocked:
				child_node.move()
			was_blocked = false
		else: # moving against a wall
			if !was_blocked:
				events.emit_signal("new_message", tr("BLOCKED"))
			turn_completed = false
			was_blocked = true
	else: # moving outside the bounds
		if !was_blocked:
			events.emit_signal("new_message", tr("OUT_OF_BOUNDS"))
		turn_completed = false
		was_blocked = true
	return turn_completed

func passive_interact(child_node: Actor) -> bool:
	var blocked = false
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if is_inside_bounds(grid_pos):
		if get_cellv(grid_pos) == -1:
			# enemies
			for enemy in enemies:
				if grid_pos == world_to_map(enemy.position):
					blocked = true
					break
			# allies
			for ally in allies:
				if grid_pos == world_to_map(ally.position):
					blocked = true
					break
			# objects
			for object in objects:
				if grid_pos == world_to_map(object.position):
					blocked = true
					break
		else: # moving against a wall
			blocked = true
	else: # moving outside the bounds
		blocked = true
	# movement
	if blocked:
		events.emit_signal("new_message", tr("BLOCKED"))
	else:
		child_node.move()
	return !blocked

func enemy_interact(child_node: Enemy) -> void:
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if is_inside_bounds(grid_pos):
		if get_cellv(grid_pos) == -1:
			var blocked = false
			# player
			if grid_pos == world_to_map(Player.position):
				child_node.basic_attack(Player)
				blocked = true
			# allies
			if allies.size() != 0:
				for i in range(allies.size() - 1, -1, -1):
					var ally = allies[i]
					if grid_pos == world_to_map(ally.position):
						child_node.basic_attack(ally)
						blocked = true
						break
			# other enemies
			for enemy in enemies:
				if grid_pos == world_to_map(enemy.position):
					blocked = true
					break
			# objects
			for object in objects:
				if grid_pos == world_to_map(object.position):
					blocked = true
					break
			# movement
			if !blocked:
				child_node.move()

func is_inside_bounds(point: Vector2) -> bool:
	var horizontal_boundaries = point.x >= data.map_top_left_corner.x and point.x < (data.map_right_bottom_corner).x
	var vertical_boundaries = point.y >= data.map_top_left_corner.y and point.y < (data.map_right_bottom_corner).y
	return horizontal_boundaries && vertical_boundaries

func end_turn() -> void:
	if Player.status == en.STATUS.DEAD:
		events.emit_signal("game_over", floor_n, get_current().entity_name)
	else:
		goto_next()
		events.emit_signal("turn_started", get_current())

func get_current() -> Actor:
	return actors[current_index]

func goto_next() -> void:
	current_index += 1
	if current_index > len(actors) - 1:
		current_index = 0
