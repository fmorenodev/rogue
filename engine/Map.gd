extends Node

onready var Grid = $Grid

var path
var map_rect

var borders = Rect2(1, 1, 38, 22)


	
func build_level():
	#Grid.clear() ?
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(300)
	
	#exit.position = walker.rooms.back().position * grid_size
	#exit.position = walker.get_end_room() * grid_size
	walker.queue_free()
	for location in map:
		Grid.set_cellv(location, -1)
	Grid.update_bitmask_region(borders.position, borders.end)
	Grid.initialize(walker.rooms)

func _ready(): 
	randomize()
	var _err = events.connect("build_level", self, "build_level")
	build_level()
	
func _input(event):
	if event.is_action_pressed('ui_select'):
		# build_level()
		get_tree().reload_current_scene()
	#if event.is_action_pressed("wait"):
		#events.emit_signal("game_over", -1, "bruh")
