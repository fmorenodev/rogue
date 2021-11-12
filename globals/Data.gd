extends Node

var map_size = Vector2(31, 21) # it's better not to use even values because it will misplace the center of the map
var map_top_left_corner = Vector2(ceil(-map_size.x / 2), floor(-map_size.y / 2))
var map_center_point = Vector2(map_top_left_corner + (map_size / 2)).ceil()
var map_right_bottom_corner = Vector2(ceil(map_size.x / 2), floor(map_size.y / 2))
var map_rect = Rect2(map_top_left_corner, map_size)
var map_seed: int

var pathfinding: AStar2D

var entities: Array = []

var tabs = {tr("INVENTORY"): 0, tr("SKILLS"): 1}

func is_entity_in_position(pos: Vector2):
	for e in entities:
		if e.position == pos:
			return e
	return null

# center_tile is in world coordinates
func calc_area(center_tile: Vector2, tile_radius: int) -> PoolVector2Array:
	var tiles_affected = []
	if tile_radius < 1:
		tiles_affected.append(center_tile)
	else:
		var side_n = 2 * tile_radius + 1
		var top_left = center_tile - Vector2(tile_radius * 16, tile_radius * 16)
		for i in side_n:
			for j in side_n:
				tiles_affected.append(Vector2(top_left.x + i * 16, top_left.y + j * 16))
	return tiles_affected
