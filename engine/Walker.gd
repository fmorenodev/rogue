extends Node
class_name Walker

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var rooms = []

func _init(start_pos: Vector2, new_borders: Rect2) -> void:
	assert(new_borders.has_point(start_pos))
	position = start_pos
	step_history.append(position)
	borders = new_borders
	
func walk(steps: int) -> Array:
	place_room()
	for step in steps:
		#if randf() < 0.5 and steps_since_turn >= 6: 
		if steps_since_turn >= 6:
			place_room()
			change_direction()
		if step():
			step_history.append(position)
		else:
			change_direction()
	return step_history
	
func step() -> bool:
	var target_pos = position + direction
	if borders.has_point(target_pos):
		steps_since_turn += 1
		position = target_pos
		return true
	else:
		return false
		
func change_direction() -> void:
	steps_since_turn = 0
	var directions = dir.BASIC_DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func place_room() -> void:
	var size = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	var top_left_corner = (position - size/2).ceil()
	var new_room = Rect2(top_left_corner, size)
	new_room = merge_rooms(new_room)
	var temp_step_history = []
	for y in new_room.size.y:
		for x in new_room.size.x:
			var new_step = new_room.position + Vector2(x, y)
			if !borders.has_point(new_step):
				new_room = trim_room(new_room)
				break
	if new_room.size.x > 1 and new_room.size.y > 1:
		for y in new_room.size.y:
			for x in new_room.size.x:
				var new_step = new_room.position + Vector2(x, y)
				if borders.has_point(new_step):
					temp_step_history.append(new_step)
		step_history = step_history + temp_step_history
		rooms.append(new_room)
	else:
		for i in steps_since_turn:
			step_history.pop_back()
		position = step_history.back()

func merge_rooms(new_room: Rect2) -> Rect2:
	var size = rooms.size() - 1
	for i in range(size, -1, -1):
		if new_room.encloses(rooms[i]) or rooms[i].encloses(new_room):
			new_room = new_room.merge(rooms[i])
			rooms.remove(i)
	return new_room
	
func trim_room(room: Rect2) -> Rect2:
	var starting_point = room.position
	var trimmed_room = room
	var is_top = starting_point.y < borders.position.y
	var is_left = starting_point.x < borders.position.x
	var is_bottom = room.end.y > borders.end.y
	var is_right = room.end.x > borders.end.x

	if is_top:
		for y in range (1, trimmed_room.size.y):
			if borders.position.y <= (starting_point.y + y):
				trimmed_room = Rect2(trimmed_room.position + Vector2(0, y), Vector2(trimmed_room.size.x, trimmed_room.size.y - y))
				break
	elif is_bottom:
		var temp_point = starting_point + Vector2(0, trimmed_room.size.y - 1)
		for y in range (1, trimmed_room.size.y):
			if borders.end.y >= (temp_point.y - y):
				trimmed_room = Rect2(trimmed_room.position, Vector2(trimmed_room.size.x, trimmed_room.size.y - y))
				break
	if is_left:
		for x in range(1, trimmed_room.size.x):
			if borders.position.x <= (starting_point.x + x):
				trimmed_room = Rect2(trimmed_room.position + Vector2(x, 0), Vector2(trimmed_room.size.x - x, trimmed_room.size.y))
				break
	elif is_right:
		var temp_point = starting_point + Vector2(trimmed_room.size.x - 1, 0)
		for x in range (1, trimmed_room.size.x):
			if borders.end.x >= (temp_point.x - x):
				trimmed_room = Rect2(trimmed_room.position, Vector2(trimmed_room.size.x - x, trimmed_room.size.y))
				break
	return trimmed_room
