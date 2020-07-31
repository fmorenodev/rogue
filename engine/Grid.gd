extends TileMap

onready var Enemy = preload("res://entities/Skeleton.tscn")
onready var Chest = preload("res://objects/Chest.tscn")
onready var Potion = preload("res://items/Potion.tscn")

var tile_size = get_cell_size()
var top_left
var bottom_right
var grid_size
var n_enemies = 10
var n_objects = 10
var n_items = 10
onready var Player = $Player
var enemies = []
var objects = []
var items = []

# implement tile_type when using 
enum TILE_TYPE {FLOOR, WALL}

func _ready():
	randomize()
	
func initialize():
	Player.position = get_available_position()
	spawn_enemies()
	spawn_objects()
	spawn_items()
	
func spawn_enemies():
	for enemy in enemies:
		enemy.queue_free()
	enemies.clear()
	
	for _i in range(n_enemies):
		var enemy = Enemy.instance()
		enemy.position = get_available_position()
		enemies.append(enemy)
		add_child(enemy)	

func spawn_objects():
	for object in objects:
		object.queue_free()
		objects.clear()
	
	for _i in range(n_objects):
		var object = Chest.instance()
		object.position = get_available_position()
		objects.append(object)
		add_child(object)
		
func spawn_items():
	for item in items:
		item.queue_free()
	items.clear()
	
	for _i in range(n_items):
		var item = Potion.instance()
		item.init(item.TYPE.HEALTH_L)
		item.position = get_available_position()
		items.append(item)
		add_child(item)

# func clear():
	
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
	if grid_pos.x > top_left.x and grid_pos.x < bottom_right.x - 1: # horizontal bounds
		if grid_pos.y > top_left.y and grid_pos.y < bottom_right.y - 1: # vertical bounds
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
					
func enemy_interact(child_node):
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if grid_pos.x > top_left.x and grid_pos.x < bottom_right.x - 1: # horizontal bounds
		if grid_pos.y > top_left.y and grid_pos.y < bottom_right.y - 1: # vertical bounds
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









