extends Node2D

var Room = preload("res://Room.tscn")
onready var Map = $Grid

var tile_size = 16
var n_rooms = 25 + randi() % 10 # 10-30 rooms 
var min_size = 4
var max_size = 10
var h_spread = 600 # horizontal spread of the map
var v_spread = 200 # vertical spread of the map
var cull = 0.5 # rate of room deletion

var path

func _ready(): 
	OS.set_window_size(Vector2(1280, 720))
	randomize()
	make_rooms()
	
func make_rooms():
	for i in range(n_rooms):
		var pos = Vector2(rand_range(-h_spread, h_spread), rand_range(-v_spread, v_spread))
		var room = Room.instance()
		var width = min_size + randi() % (max_size - min_size)
		var height = min_size + randi() % (max_size - min_size)
		room.make_room(pos, Vector2(width, height) * tile_size)
		$Rooms.add_child(room)
		
	yield(get_tree().create_timer(0.75), "timeout")
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(room.position)
	yield(get_tree(), "idle_frame")
	path = find_mst(room_positions)
			
func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(0, 1, 0), false)
	if path:
		for point in path.get_points():
			for connection in path.get_point_connections(point):
				var point_pos = path.get_point_position(point)
				var con_pos = path.get_point_position(connection)
				draw_line(Vector2(point_pos.x, point_pos.y), Vector2(con_pos.x,
					con_pos.y), Color(1, 1, 0), 15, true)

func _process(_delta):
	update()
	
func _input(event):
	if event.is_action_pressed('ui_select'):
		Map.clear()
		for n in $Rooms.get_children():
			n.queue_free()
		path = null
		make_rooms()
	if event.is_action_pressed("ui_focus_next"):
		make_map()

func find_mst(nodes):
	# Prim's algorithm
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_dist = INF # min distance so far
		var min_pos = null # position of that node (with the min distance)
		var cur_pos = null # current position
		for p1 in path.get_points(): # look for the min_dist between p1 and p2
			p1 = path.get_point_position(p1)
			# rest of the nodes
			for p2 in nodes: 
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_pos = p2
					cur_pos = p1
		var n = path.get_available_point_id()
		path.add_point(n, min_pos)
		path.connect_points(path.get_closest_point(cur_pos), n)
		nodes.erase(min_pos)
	return path

func make_map():
	Map.clear()
	
	# full_rect will be the size of the map
	var full_rect = Rect2()
	# merge all the rooms together to get the minimum size that encompasses all rooms
	for room in $Rooms.get_children():
		var r = Rect2(room.position - room.size, 
			room.get_node("CollisionShape2D").shape.extents * 2)
		full_rect = full_rect.merge(r)
	var top_left = Map.world_to_map(full_rect.position)
	var bottom_right = Map.world_to_map(full_rect.end)
	# fill the map with wall tiles
	for x in range(top_left.x, bottom_right.x):
		for y in range(top_left.y, bottom_right.y):
			Map.set_cell(x, y, 1)

	# add the room and corridor floor tiles
	var corridors = []
	for room in $Rooms.get_children():
		# tiles for the rooms
		var half_size = (room.size / tile_size).floor() # half size in tiles
		var pos = Map.world_to_map(room.position)
		var room_top_left = (room.position / tile_size).floor() - half_size
		for x in range(2, half_size.x * 2 - 1):
			for y in range(2, half_size.y * 2 - 1):
				Map.set_cell(room_top_left.x + x, room_top_left.y + y, 0)
				
		# tiles for the corridors
		var point = path.get_closest_point(room.position)
		for connection in path.get_point_connections(point):
			if not connection in corridors:
				var start = Map.world_to_map(path.get_point_position(point))
				var end = Map.world_to_map(path.get_point_position(connection))
				carve_path(start, end)
		corridors.append(point)
		
func carve_path(pos1, pos2):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	# if they are aligned in the axis, pick a random direction
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2) 
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, 0)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, 0)
