extends Control

onready var Loading_Text = $Background/LoadingText

func _ready() -> void:
	Loading_Text.text = tr("LOADING_TEXT")
	var _err = events.connect("level_loaded", self, "_on_level_loaded")
	_err = events.connect("new_game", self, "_on_new_game")
	
func _on_level_loaded() -> void:
	self.hide()
	
func _on_new_game() -> void:
	self.show()
