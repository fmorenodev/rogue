extends Node2D

func _ready() -> void:
	var _err = events.connect("reload_all", self, "_on_reload_all")
	events.emit_signal("new_game")
	events.emit_signal("play_music", en.MUSIC.MAIN)

func _on_reload_all() -> void:
	var _err = get_tree().reload_current_scene()
