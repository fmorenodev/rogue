extends TileMap

onready var Skeleton = preload("res://actors/Skeleton.tscn")
onready var Chest = preload("res://objects/Chest.tscn")
onready var Potion = preload("res://items/Potion.tscn")

# grid properties
var tile_size = get_cell_size()
var top_left 
var bottom_right
var grid_size

# grid elements
onready var Player = $Player
onready var Enemy = $Enemy
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
	randomize()
	var _err = events.connect("new_game", self, "_on_new_game")
	_err = events.connect("turn_started", Enemy, "_on_Grid_turn_started")
	_err = events.connect("turn_started", Player, "_on_Grid_turn_started")
	
func _on_new_game():
	setup_player()
	
func initialize():
	clean_up()
	spawn_player()
	spawn_enemies()
	spawn_objects()
	spawn_items()
	# if !events.is_connected("turn_started", Enemy, "_on_Grid_turn_started"):
	
func clean_up():
	actors = [null]
	current_index = 0
	for enemy in enemies:
		enemy.queue_free()
	enemies.clear()
	
	for object in objects:
		object.queue_free()
	objects.clear()	
	
	for item in items:
		item.queue_free()
	items.clear()

func spawn_player():
	Player.position = get_available_position()
	actors[0] = Player
		
func setup_player():
	Player.init()
	# if !events.is_connected("turn_started", Player, "_on_Grid_turn_started"):
	
func spawn_enemies():	
	for _i in range(n_enemies):
		var enemy = Skeleton.instance()
		enemy.position = get_available_position()
		enemies.append(enemy)
		actors.append(enemy)
		add_child(enemy)
		enemy.add_to_group("enemies")

func spawn_objects():
	for _i in range(n_objects):
		var object = Chest.instance()
		object.position = get_available_position()
		objects.append(object)
		add_child(object)
		
func spawn_items():
	for _i in range(n_items):
		var item = Potion.instance()
		item.init(item.TYPE.HEALTH_L)
		item.position = get_available_position()
		items.append(item)
		add_child(item)
		
func get_available_position(excluded = [Vector2()]):
	var rooms = get_node("../Rooms").get_children()
	var chosen_room = rooms[randi() % rooms.size()]
	var room_top_left = world_to_map(chosen_room.rect.position)
	var room_bottom_right = world_to_map(chosen_room.rect.end)
	
	var	pos = Vector2()
	while pos in excluded:
		pos = Vector2(int(rand_range(room_top_left.x + 2, room_bottom_right.x - 2)),
					  int(rand_range(room_top_left.y + 2, room_bottom_right.y - 2)))
	
	if pos == Player.position:
		excluded.append(pos)
		get_available_position(excluded)
	for enemy in enemies: 
		if pos == enemy.position:
			excluded.append(pos)
			get_available_position(excluded)
	for object in objects:
		if pos == object.position:
			excluded.append(pos)
			get_available_position(excluded)
	for item in items:
		if pos == item.position:
			excluded.append(pos)
			get_available_position(excluded)
	
	return map_to_world(pos)

func interact(child_node):
	var turn_completed = true
	if child_node.direction == Vector2():
		return turn_completed
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if is_inside_bounds(grid_pos.x, grid_pos.y):
		if get_cellv(grid_pos) == 0:
			var blocked = false
			var to_remove = []
			# enemy
			for enemy in enemies:
				if grid_pos == world_to_map(enemy.position):
					var damage = enemy.take_damage(child_node.attack)
					events.emit_signal("new_message", tr("PLAYER_ATTACK"),
						"8ffcff", [enemy.actor_name, damage])
					if enemy.status == en.STATUS.DEAD:
						to_remove.append(enemy)
						events.emit_signal("new_message", tr("ENEMY_DEAD"),
							"a70000", [enemy.actor_name])
					blocked = true
					break
			# object
			for object in objects:
				if grid_pos == world_to_map(object.position):
					if object.can_interact:
						object.interact()
						events.emit_signal("new_message", tr(object.interaction),
							"ffd046", object.args)
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
							"ffffff", [item.item_name])
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
	if is_inside_bounds(grid_pos.x, grid_pos.y):
		if get_cellv(grid_pos) == 0:
			var blocked = false
			# Player
			if grid_pos == world_to_map(Player.position):
				# handle player game over
				var damage = Player.take_damage(child_node.attack)
				events.emit_signal("new_message", tr("OTHER_ATTACK"),
						"ff5252", [child_node.actor_name, Player.actor_name.to_lower(), damage])
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

func is_inside_bounds(x, y):
	var horizontal_bounds = x > top_left.x and x < bottom_right.x - 1
	var vertical_bounds = y > top_left.y and y < bottom_right.y - 1
	return horizontal_bounds and vertical_bounds

func end_turn():
	goto_next()
	events.emit_signal("turn_started", get_current())

func get_current():
	return actors[current_index]

func goto_next() -> void:
	current_index += 1

	if current_index > len(actors) - 1:
		current_index = 0
