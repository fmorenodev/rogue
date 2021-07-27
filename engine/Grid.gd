extends TileMap

onready var Skeleton = preload("res://actors/enemies/Skeleton.tscn")
onready var Chest = preload("res://objects/Chest.tscn")
onready var Potion = preload("res://items/Potion.tscn")


# grid elements
onready var Player = $Player
onready var Enemy = $Enemy
var entities = []
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

func _ready():
	set_physics_process(false)
	randomize()
	var _err = events.connect("new_game", self, "_on_new_game")
	_err = events.connect("turn_started", Enemy, "_on_Grid_turn_started")
	_err = events.connect("turn_started", Player, "_on_Grid_turn_started")
	_err = events.connect("game_over", Player, "_on_game_over")
	_err = events.connect("level_loaded", Player, "_on_Grid_level_loaded")
	_err = events.connect("level_loaded", self, "_on_Grid_level_loaded")
	
func _on_Grid_level_loaded():
	set_physics_process(true)
	
func _on_new_game():
	events.emit_signal("new_message", tr("GAME_START"))
	Player.manual_init()
	for enemy in enemies:
		enemy.manual_init()
	for object in objects:
		object.manual_init()
	for item in items:
		item.manual_init()
	
func init(grid_rooms):
	rooms = grid_rooms
	for r in rooms:
		detect_passages(detect_borders(r))
	clean_up()
	spawn_player()
	spawn_items()
	spawn_enemies()
	spawn_objects()
	events.emit_signal("new_message", tr("LEVEL_ENTERED"), color.grey)
	events.emit_signal("level_loaded")
	
func clean_up():
	actors = [null]
	current_index = 0
	for enemy in enemies:
		enemy.remove()
	for object in objects:
		object.remove()
	for item in items:
		item.remove()

func spawn_player():
	var pos = get_available_position()
	if pos != null:
		Player.position = pos
	actors[0] = Player
	entities.append(Player)
	
func spawn_enemies():
	for _i in range(n_enemies):
		var enemy = Skeleton.instance()
		var pos = get_available_position()
		if pos != null:
			enemy.position = pos
		enemies.append(enemy)
		actors.append(enemy)
		add_child(enemy)
		entities.append(enemy)
		enemy.add_to_group("enemies")

func spawn_objects():
	for _i in range(n_objects):
		var object = Chest.instance()
		var pos = get_available_position()
		if pos != null:
			object.position = pos
		objects.append(object)
		add_child(object)
		entities.append(object)
		
func spawn_items():
	for _i in range(n_items):
		var item = Potion.instance()
		item.add_type(en.POTION_TYPE.values()[randi() % 4])
		var pos = get_available_position()
		if pos != null:
			item.position = pos
		items.append(item)
		add_child(item)
		entities.append(item)
		
func get_available_position():
	var pos
	pos = get_room_and_pos()
	while true:
		if is_pos_available(pos):
			return pos
		else:
			pos = get_room_and_pos()

func get_room_and_pos():
	var chosen_room = rooms[randi() % rooms.size()]
	var room_top_left = chosen_room.position
	var room_bottom_right = chosen_room.end
	var pos = map_to_world(Vector2(int(rand_range(room_top_left.x, room_bottom_right.x - 1)),
		int(rand_range(room_top_left.y, room_bottom_right.y - 1))))
	return pos

func is_pos_available(pos):
	for e in entities:
		if e.position == pos:
			return false
	return true

# have to merge rooms to make it work 100%, but this should be able to detect 
# the entrance point of corridors in the right circumstances
func detect_passages(borders):
	var passages = []
	var point
	for i in borders.top_borders.size():
		point = borders.top_borders[i] + Vector2.UP
		if get_cellv(point) == -1:
			passages.append(point - Vector2.UP)
	for i in borders.bottom_borders.size():
		point = borders.bottom_borders[i] + Vector2.DOWN
		if get_cellv(point) == -1:
			passages.append(point - Vector2.DOWN)
	for i in borders.left_borders.size():
		point = borders.left_borders[i] + Vector2.LEFT
		if get_cellv(point) == -1:
			passages.append(point - Vector2.LEFT)
	for i in borders.right_borders.size():
		point = borders.right_borders[i] + Vector2.RIGHT
		if get_cellv(point) == -1:
			passages.append(point - Vector2.RIGHT)
	return passages

func detect_borders(room):
	var borders = {
		"top_borders": [],
		"bottom_borders": [],
		"left_borders": [],
		"right_borders": []
	}
	for x in room.size.x:
		borders.top_borders.append(room.position + Vector2(x, 0))
		borders.bottom_borders.append((room.end - Vector2.ONE) + Vector2(-x, 0))
	for y in room.size.y:
		borders.left_borders.append(room.position + Vector2(0, y))
		borders.right_borders.append((room.end - Vector2.ONE) + Vector2(0, -y))
	return borders

# debugging function
func _draw():
	for room in rooms:
		draw_rect(Rect2(map_to_world(room.position), map_to_world(room.size)), Color.from_hsv(rand_range(0, 6), 1, 1), true)

func interact(child_node):
	var turn_completed = true
	if child_node.direction == Vector2():
		return turn_completed
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if is_inside_bounds(grid_pos):
		if get_cellv(grid_pos) == -1 or true:
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
						item.pick_up(child_node)
						events.emit_signal("new_message", tr("ITEM_PICK"), 
							color.white, [item.item_name])
						to_remove.append(item)
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
					
func enemy_interact(child_node):
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

func is_inside_bounds(point):
	var horizontal_boundaries = point.x >= data.map_top_left_corner.x and point.x < (data.map_right_bottom_corner).x
	var vertical_boundaries = point.y >= data.map_top_left_corner.y and point.y < (data.map_right_bottom_corner).y
	return horizontal_boundaries && vertical_boundaries

func end_turn():
	goto_next()
	events.emit_signal("turn_started", get_current())

func get_current():
	return actors[current_index]

func goto_next() -> void:
	current_index += 1

	if current_index > len(actors) - 1:
		current_index = 0
