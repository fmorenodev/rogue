extends Node

var map_size = Vector2(31, 21) # it's better not to use even values because it will misplace the center of the map
var map_top_left_corner = Vector2(ceil(-map_size.x / 2), floor(-map_size.y / 2))
var map_center_point = Vector2(map_top_left_corner + (map_size / 2)).ceil()
var map_right_bottom_corner = Vector2(ceil(map_size.x / 2), floor(map_size.y / 2))
var map_rect = Rect2(map_top_left_corner, map_size)
var map_seed: int

var pathfinding: AStar2D

var entities: Array = []

func is_entity_in_position(pos: Vector2):
	for e in entities:
		if e.position == pos:
			return e
	return false

var tabs = {tr("INVENTORY"): 0, tr("SKILLS"): 1}
