extends TileMap

#
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

# turn queue
var actors = [null]
var current_index = 0
signal turn_started(current_actor)

func _ready():
	randomize()
	
func initialize():
	clean_up()
	setup_player()
	spawn_enemies()
	spawn_objects()
	spawn_items()
	if !is_connected("turn_started", $Enemy, "_on_Grid_turn_started"):
		connect("turn_started", $Enemy, "_on_Grid_turn_started")
	
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
	
func setup_player():
	Player.position = get_available_position()
	actors[0] = Player
	if !is_connected("turn_started", Player, "_on_Grid_turn_started"):
		connect("turn_started", Player, "_on_Grid_turn_started")
	
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

	for enemy in enemies: 
		if pos == enemy.position:
			excluded.append(pos)
			get_available_position(excluded)
	for object in objects:
		if pos == object.position:
			excluded.append(position)
			get_available_position(excluded)
	for item in items:
		if pos == item.position:
			excluded.append(position)
			get_available_position(excluded)
	
	return map_to_world(pos)

func interact(child_node):
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	var turn_completed = true
	if is_inside_bounds(grid_pos.x, grid_pos.y):
		if get_cellv(grid_pos) == 0:
			var blocked = false
			var to_remove = []
			# enemy
			for enemy in enemies:
				if grid_pos == world_to_map(enemy.position):
					enemy.take_damage(child_node.attack)
					if enemy.status == en.STATUS.DEAD:
						to_remove.append(enemy)
					blocked = true
					break
			# object
			for object in objects:
				if grid_pos == world_to_map(object.position):
					if object.can_interact:
						object.interact()
					else:
						turn_completed = false
						print(tr("BLOCKED"))
					blocked = true
					break
			# items
			for item in items:
				if grid_pos == world_to_map(item.position):
					item.pick_up(child_node)
					to_remove.append(item)
					break
					
			for o in to_remove:
				o.remove()
			# movement
			if !blocked:
				child_node.move()
		else: # moving against a wall
			print(tr("BLOCKED"))
			turn_completed = false
	else: # moving outside the bounds
		print(tr("OUT_OF_BOUNDS"))
		turn_completed = false
	
	return turn_completed
					
func enemy_interact(child_node):
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if is_inside_bounds(grid_pos.x, grid_pos.y):
		if get_cellv(grid_pos) == 0:
			var blocked = false
			# Player
			if grid_pos == world_to_map(Player.position):
				Player.take_damage(child_node.attack)
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
	#print("{0}: End turn.".format([get_current().name]))
	goto_next()
	emit_signal("turn_started", get_current())

func get_current():
	return actors[current_index]

func goto_next() -> void:
	current_index += 1

	if current_index > len(actors) - 1:
		current_index = 0






