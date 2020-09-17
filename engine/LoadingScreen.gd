extends Control

onready var Loading_Text = $Background/LoadingText

func _ready():
	Loading_Text.text = tr("LOADING_TEXT")
	var _err = events.connect("level_loaded", self, "_on_level_loaded")
	_err = events.connect("new_game", self, "_on_new_game")
	
func _on_level_loaded():
	self.hide()
	
func _on_new_game():
	self.show()
