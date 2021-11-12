extends AudioStreamPlayer

func _ready() -> void:
	var _err = connect("play_sound", self, "_on_play_sound")
	
func _on_play_sound(sound) -> void:
	pass
