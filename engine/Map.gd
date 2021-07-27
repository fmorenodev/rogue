extends Node

onready var Grid = $Grid
onready var borders = Rect2(data.map_top_left_corner, data.map_size)

func build_level():
	randomize()
	var walker = Walker.new(data.map_center_point, borders)
	var map = walker.walk(300)
	
	#exit.position = walker.rooms.back().position * grid_size
	#exit.position = walker.get_end_room() * grid_size
	for location in map:
		Grid.set_cellv(location, -1)
	Grid.update_bitmask_region(borders.position, borders.end - Vector2.ONE)
	Grid.init(walker.rooms)
	walker.queue_free()

func _ready(): 
	randomize()
	var _err = events.connect("build_level", self, "build_level")
	build_level()
	
func _input(event):
	if event.is_action_pressed('ui_select'):
		var _err = get_tree().reload_current_scene()
	if event.is_action_pressed("wait"):
		events.emit_signal("game_over", -1, "debug")
