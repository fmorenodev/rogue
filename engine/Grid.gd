extends TileMap

onready var Skeleton = preload("res://actors/enemies/Skeleton.tscn")
onready var Potion = preload("res://items/Potion.tscn")

# grid elements
onready var Player = $Player
onready var Enemy = $Enemy
var rooms = []
var enemies = []
var objects = []
var items = []
var n_enemies = 10
var n_objects = 10
var n_items = 10

# game variables
var floor_n = -1

# turn queue
var actors = [null]
var current_index = 0

func _ready() -> void:
	set_physics_process(false)
	randomize()
	var _err = events.connect("new_game", self, "_on_new_game")
	_err = events.connect("turn_started", Enemy, "_on_Grid_turn_started")
	_err = events.connect("turn_started", Player, "_on_Grid_turn_started")
	_err = events.connect("game_over", Player, "_on_game_over")
	_err = events.connect("level_loaded", Player, "_on_Grid_level_loaded")
	_err = events.connect("level_loaded", self, "_on_Grid_level_loaded")
	_err = events.connect("entity_removed", self, "_on_Grid_entity_removed")
	
	_err = events.connect("item_spawned", self, "spawn_item")
	
func _on_Grid_level_loaded() -> void:
	set_physics_process(true)
	
func _on_new_game() -> void:
	events.emit_signal("new_message", tr("GAME_START"))
	Player.manual_init()
	for enemy in enemies:
		enemy.manual_init()
	for object in objects:
		object.manual_init()
	for item in items:
		item.manual_init()
	
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
	actors[0] = Player
	data.entities.append(Player)
	
func spawn_enemies() -> void:
	for _i in range(n_enemies):
		var enemy = Skeleton.instance()
		enemy.position = get_available_position()
		enemies.append(enemy)
		actors.append(enemy)
		add_child(enemy)
		data.entities.append(enemy)
		enemy.add_to_group("enemies")
		
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
		var item = Potion.instance()
		item.add_type(en.POTION_TYPE.values()[randi() % 4])
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

func interact(child_node: Actor) -> bool:
	var turn_completed = true
	if child_node.direction == Vector2():
		return turn_completed
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if is_inside_bounds(grid_pos):
		if get_cellv(grid_pos) == -1:
			var blocked = false
			var to_remove = []
			# enemy
			for enemy in enemies:
				if grid_pos == world_to_map(enemy.position):
					var damage = enemy.take_damage(child_node.attack)
					events.emit_signal("new_message", tr("PLAYER_ATTACK"),
						color.cyan, [enemy.actor_name, damage])
					if enemy.status == en.STATUS.DEAD:
						to_remove.append(enemy)
						events.emit_signal("new_message", tr("ENEMY_DEAD"),
							color.red, [enemy.actor_name])
					blocked = true
					break
			# object
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
								color.white, [item.item_name])
							to_remove.append(item)
						else:
							events.emit_signal("new_message", tr("INV_FULL"),
								color.white, [item.item_name])
							
						break
			for o in to_remove:
				o.remove()
			# movement
			if !blocked:
				child_node.move()
		else: # moving against a wall
			events.emit_signal("new_message", tr("BLOCKED"))
			turn_completed = false
	else: # moving outside the bounds
		events.emit_signal("new_message", tr("OUT_OF_BOUNDS"))
		turn_completed = false
	return turn_completed
					
func enemy_interact(child_node: Enemy) -> void:
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if is_inside_bounds(grid_pos):
		if get_cellv(grid_pos) == -1:
			var blocked = false
			# Player
			if grid_pos == world_to_map(Player.position):
				var damage = Player.take_damage(child_node.attack)
				events.emit_signal("new_message", tr("OTHER_ATTACK"),
						color.light_red, [child_node.actor_name, Player.actor_name.to_lower(), damage])
				if Player.status == en.STATUS.DEAD:
					events.emit_signal("game_over", floor_n, child_node.actor_name)
				blocked = true
			# other enemies
			for enemy in enemies:
				if grid_pos == world_to_map(enemy.position):
					blocked = true
					break
			# object
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
	goto_next()
	events.emit_signal("turn_started", get_current())

func get_current() -> Actor:
	return actors[current_index]

func goto_next() -> void:
	current_index += 1
	if current_index > len(actors) - 1:
		current_index = 0
