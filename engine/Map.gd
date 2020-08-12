extends Node2D

var Room = preload("res://engine/Room.tscn")
onready var Player = $Grid/Player
onready var Camera = $Grid/Player/Camera2D
onready var Grid = $Grid
var debug_mode = false

onready var tile_size = Grid.tile_size
export var min_rooms = 10 # min_rooms
export var max_room_variation = 10 # modulo for the randi
export var min_size = 4
export var max_size = 10
export var h_spread = 200 # horizontal spread of the map
export var v_spread = 400 # vertical spread of the map
var cull = 0 # rate of room deletion (0 -> 1)

var path
var map_rect

func _ready(): 
	randomize()
	var _err = events.connect("build_level", self, "build_level")
	build_level()
	
func _draw():
	if debug_mode:
		for room in $Rooms.get_children():
			draw_rect(Rect2(room.position - room.size, room.size * 2), Color(0, 1, 0), false)
			if room.rect:
				draw_rect(room.rect, Color(0, 1, 1), false)
		if path:
			for point in path.get_points():
				for connection in path.get_point_connections(point):
					var point_pos = path.get_point_position(point)
					var con_pos = path.get_point_position(connection)
					draw_line(Vector2(point_pos.x, point_pos.y), Vector2(con_pos.x,
						con_pos.y), Color(1, 1, 0), 15, true)
		if map_rect:
			draw_rect(map_rect, Color(1, 1, 1), false)

func _process(_delta):
	update() # for debug mode drawings
	
func _input(event):
	if event.is_action_pressed('ui_select'):
		build_level()
	if event.is_action_pressed("ui_focus_next"):
		debug_mode = not debug_mode
		build_level()
	if event.is_action_pressed("scroll_up"):
		if debug_mode:
			if Camera.zoom > Vector2(1, 1):
				Camera.zoom -= Vector2(0.5, 0.5)
	if event.is_action_pressed("scroll_down"):
		if debug_mode:
			if Camera.zoom < Vector2(7, 7):
				Camera.zoom += Vector2(0.5, 0.5)
	
func build_level():
	Grid.clear()
	events.emit_signal("new_message_newline", tr("LEVEL_ENTERED"), "fcba03")
	for n in $Rooms.get_children():
		$Rooms.remove_child(n)
		n.queue_free()
	path = null
	make_map()
	
func make_rooms():
	var n_rooms = min_rooms + randi() % max_room_variation
	for _i in range(n_rooms):
		var pos = Vector2(rand_range(-h_spread, h_spread), rand_range(-v_spread, v_spread))
		var room = Room.instance()
		var width = min_size + randi() % (max_size - min_size)
		var height = min_size + randi() % (max_size - min_size)
		room.make_room(pos, Vector2(width, height) * tile_size)
		$Rooms.add_child(room) 
		
	yield(get_tree().create_timer(0.75), "timeout")
	var room_positions = []
	for room in $Rooms.get_children():
		# culling not working properly sometimes
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(room.position)
	yield(get_tree(), "idle_frame")
	path = find_mst(room_positions)
			
func find_mst(nodes):
	# Prim's algorithm
	var new_path = AStar2D.new()
	new_path.add_point(new_path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_dist = INF # min distance so far
		var min_pos = null # position of that node (with the min distance)
		var cur_pos = null # current position
		for p1 in new_path.get_points(): # look for the min_dist between p1 and p2
			p1 = new_path.get_point_position(p1)
			# rest of the nodes
			for p2 in nodes: 
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_pos = p2
					cur_pos = p1
		var n = new_path.get_available_point_id()
		new_path.add_point(n, min_pos)
		new_path.connect_points(new_path.get_closest_point(cur_pos), n)
		nodes.erase(min_pos)
	return new_path

func make_map():	
	yield(make_rooms(), "completed")
	Grid.clear()
	map_rect = Rect2()
	# merge all the rooms together to get the minimum size that encompasses all rooms
	for room in $Rooms.get_children():
		room.position = room.position
		room.size = room.size
		var r = Rect2((room.position - room.size), 
			(room.get_node("CollisionShape2D").shape.extents * 2))
		room.rect = r
		map_rect = map_rect.merge(r)
	var top_left = Grid.world_to_map(map_rect.position)
	var bottom_right = Grid.world_to_map(map_rect.end)
	Grid.top_left = top_left 
	Grid.bottom_right = bottom_right
	Grid.grid_size = top_left - bottom_right
	# fill the map with wall tiles
	for x in range(top_left.x, bottom_right.x):
		for y in range(top_left.y, bottom_right.y):
			Grid.set_cell(x, y, 1)

	# add the room and corridor floor tiles
	var corridors = []
	for room in $Rooms.get_children():
		# tiles for the rooms
		var room_top_left = Grid.world_to_map(room.rect.position)
		var room_bottom_right = Grid.world_to_map(room.rect.end)
		for x in range(room_top_left.x + 2, room_bottom_right.x - 1):
			for y in range(room_top_left.y + 2, room_bottom_right.y - 1):
				Grid.set_cell(x, y, 0)

		# tiles for the corridors
		var point = path.get_closest_point(room.position)
		for connection in path.get_point_connections(point):
			if not connection in corridors:
				var start = Grid.world_to_map(path.get_point_position(point))
				var end = Grid.world_to_map(path.get_point_position(connection))
				carve_path(start, end)
		corridors.append(point)
	Grid.initialize()
		
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
		Grid.set_cell(x, x_y.y, 0)
	for y in range(pos1.y, pos2.y, y_diff):
		Grid.set_cell(y_x.x, y, 0)
	
