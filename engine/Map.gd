extends Node

onready var Grid = $Grid
onready var borders = Rect2(data.map_top_left_corner, data.map_size)

func _ready() -> void: 
	randomize()
	var _err = events.connect("build_level", self, "build_level")
	build_level()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_select'):
		var _err = get_tree().reload_current_scene()
	if event.is_action_pressed('ui_cancel'):
		events.emit_signal("game_over", -1, "debug")
		
func build_level() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	data.map_seed = rng.get_seed()
	var walker = Walker.new(data.map_center_point, borders)
	var map = walker.walk(300)
	for location in map:
		Grid.set_cellv(location, -1)
	Grid.update_bitmask_region(borders.position, borders.end - Vector2.ONE)
	Grid.init(walker.rooms)
	walker.queue_free()
