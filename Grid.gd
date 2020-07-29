extends TileMap

onready var Enemy = preload("res://entities/Skeleton.tscn")

var tile_size = get_cell_size()
var top_left
var bottom_right
var grid_size
var n_enemies = 10
var enemies = []
var objects = []
var items

enum TILE_TYPE {FLOOR, WALL}
enum INTERACTION_TYPE {NOTHING, MOVE, ATTACK, PICKUP, OTHER}
enum ENTITY_TYPES {PLAYER, ENEMY, COLLECTIBLE}

func _ready():
	randomize()
	
func initialize():
	$Player.position = get_available_position()
	
	for enemy in enemies:
		enemy.queue_free()
	enemies.clear()
	
	for _i in range(n_enemies):
		var enemy = Enemy.instance()
		enemy.position = get_available_position()
		enemies.append(enemy)
		add_child(enemy)

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
	
	return map_to_world(pos)

func interact(child_node):
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if grid_pos.x > top_left.x and grid_pos.x < bottom_right.x - 1: # horizontal bounds
		if grid_pos.y > top_left.y and grid_pos.y < bottom_right.y - 1: # vertical bounds
			if get_cellv(grid_pos) == 0:
				var blocked = false
				# enemy
				for enemy in enemies:
					print(world_to_map(enemy.position))
					print(grid_pos)
					if grid_pos == world_to_map(enemy.position):
						enemy.take_damage(child_node.attack)
						blocked = true
						break
				for object in objects:
					if grid_pos == object.position:
						#interaction
						blocked = true
						break
				# movement
				if !blocked:
					child_node.move()
					










