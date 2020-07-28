extends TileMap

var tile_size = get_cell_size()
var grid = []
var top_left
var bottom_right
var grid_size
var n_enemies = 10

enum TILE_TYPE {FLOOR, WALL}
enum INTERACTION_TYPE {NOTHING, MOVE, ATTACK, PICKUP, OTHER}
enum ENTITY_TYPES {PLAYER, ENEMY, COLLECTIBLE, COLLISION_BLOCK}

onready var Enemy = preload("res://Enemy.tscn")

func _ready():
	randomize()
	
func initialize():
	$Player.position = get_available_position()
		
func get_available_position():
	var rooms = get_node("../Rooms").get_children()
	var chosen_room = rooms[randi() % rooms.size()]
	var room_top_left = world_to_map(chosen_room.rect.position)
	var room_bottom_right = world_to_map(chosen_room.rect.end)
	var position = Vector2(int(rand_range(room_top_left.x + 2, room_bottom_right.x - 2)),
							int(rand_range(room_top_left.y + 2, room_bottom_right.y - 2)))
	return map_to_world(position)

func interact(child_node):
	var grid_pos = world_to_map(child_node.position) + child_node.direction
	if grid_pos.x > top_left.x and grid_pos.x < bottom_right.x - 1: # horizontal bounds
		if grid_pos.y > top_left.y and grid_pos.y < bottom_right.y - 1: # vertical bounds
			if get_cellv(grid_pos) == 0:
				return INTERACTION_TYPE.MOVE
	return INTERACTION_TYPE.NOTHING
