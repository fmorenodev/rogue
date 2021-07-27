extends Node2D

func _ready():
	#OS.set_window_size(Vector2(1280, 720))
	var _err = events.connect("reload_all", self, "_on_reload_all")
	events.emit_signal("new_game")
	pass

func _on_reload_all():
	var _err = get_tree().reload_current_scene()
