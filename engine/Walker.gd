extends Node
class_name Walker

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var rooms = []

func _init(start_pos, new_borders):
	assert(new_borders.has_point(start_pos))
	position = start_pos
	step_history.append(position)
	borders = new_borders
	
func walk(steps):
	place_room()
	for step in steps:
		#if randf() < 0.5 and steps_since_turn >= 6: 
		if steps_since_turn >= 6:
			change_direction()
		if step():
			step_history.append(position)
		else:
			change_direction()
	return step_history
	
func step():
	var target_pos = position + direction
	if borders.has_point(target_pos):
		steps_since_turn += 1
		position = target_pos
		return true
	else:
		return false

func change_direction():
	place_room()
	steps_since_turn = 0
	var directions = dir.DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func place_room():
	var size = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	var top_left_corner = (position - size/2).ceil()
	rooms.append(Rect2(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_end_room():
	var end_room = rooms.pop_front()
	var starting_pos = step_history.front()
	for room in rooms:
		if starting_pos.distance_to(room.position) > starting_pos.distance_to(end_room.position):
			end_room = room
	return end_room
