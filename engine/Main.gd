extends Node2D

func _ready() -> void:
	#OS.set_window_size(Vector2(1280, 720))
	var _err = events.connect("reload_all", self, "_on_reload_all")
	events.emit_signal("new_game")

func _on_reload_all() -> void:
	var _err = get_tree().reload_current_scene()
