extends TileMap

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

var grid_size = Vector2(10, 10)
var grid = []

enum ENTITY_TYPES {PLAYER, ENEMY, COLLECTIBLE}

onready var Enemy = preload("res://Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			
	var positions = []
	for n in range(5):
		var grid_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if not grid_pos in positions:
			positions.append(grid_pos)
			
	for pos in positions:
		var new_enemy = Enemy.instance()
		new_enemy.position = map_to_world(pos) + half_tile_size
		grid[pos.x][pos.y] = ENTITY_TYPES.ENEMY
		add_child(new_enemy)
		
		update_child_pos($Player)

func is_cell_vacant(pos, direction):
	var grid_pos = world_to_map(pos) + direction
	if grid_pos.x < grid_size.x and grid_pos.x >= 0: # horizontal bounds
		if grid_pos.y < grid_size.y and grid_pos.y >= 0: # vertical bounds
			if grid[grid_pos.x][grid_pos.y] == null:  # cell is empty
				return true
	return false

func update_child_pos(child_node):
	var grid_pos = world_to_map(child_node.position)
	grid[grid_pos.x][grid_pos.y] = null
	
	var new_grid_pos = grid_pos + child_node.direction
	grid[new_grid_pos.x][new_grid_pos.y] = child_node.type
	
	return map_to_world(new_grid_pos)
	
	









