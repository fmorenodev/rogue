extends Node

onready var Grid = $Grid
onready var borders = Rect2(data.map_top_left_corner, data.map_size)
var input_enabled: bool

func _ready() -> void: 
	randomize()
	var _err = events.connect("build_level", self, "build_level")
	_err = events.connect("game_over", self, "_on_game_over")
	input_enabled = true
	build_level()
	
func _input(event: InputEvent) -> void:
	if input_enabled:
		if event.is_action_pressed('open_inventory'):
			events.emit_signal("open_inventory")
		if event.is_action_pressed('open_skills'):
			events.emit_signal("open_skills")
		if event.is_action_pressed('ui_focus_next'):
			var _err = get_tree().reload_current_scene()
		if event.is_action_pressed('ui_focus_prev'):
			events.emit_signal("game_over", -1, "debug")
		
func build_level() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	data.map_seed = rng.get_seed()
	var walker = Walker.new(data.map_center_point, borders)
	var map = walker.walk(300)
	data.pathfinding = AStar2D.new()
	for pos in map:
		if Grid.get_cellv(pos) != -1:
			Grid.set_cellv(pos, -1)
			add_and_connect_point(pos)
	Grid.update_bitmask_region(borders.position, borders.end - Vector2.ONE)
	Grid.init(walker.rooms)
	walker.queue_free()
	
func add_and_connect_point(pos: Vector2) -> void:
	var new_id = data.pathfinding.get_available_point_id()
	data.pathfinding.add_point(new_id, pos)
	var points_to_connect = []
	for direction in dir.DIRECTIONS:
		if Grid.get_cellv(pos + direction) == -1:
			points_to_connect.append(data.pathfinding.get_closest_point(pos + direction))

	for point in points_to_connect:
		data.pathfinding.connect_points(new_id, point)
		
func find_step(initial_pos: Vector2, final_pos: Vector2) -> Vector2:
	var i_pos_grid = Grid.world_to_map(initial_pos)
	var pathfinding = data.pathfinding
	var i_pos = pathfinding.get_closest_point(i_pos_grid)
	var f_pos = pathfinding.get_closest_point(Grid.world_to_map(final_pos))
	var path = pathfinding.get_id_path(i_pos, f_pos)
	return pathfinding.get_point_position(path[1]) - i_pos_grid
	
func _on_game_over(_current_floor: int, _enemy_name: String) -> void:
	input_enabled = false
