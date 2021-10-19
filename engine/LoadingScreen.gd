#extends Control
#
#onready var Loading_Text = $Background/LoadingText
#
## currently unused scene
#func _ready() -> void:
#	Loading_Text.text = tr("LOADING_TEXT")
#	var _err = events.connect("level_loaded", self, "_on_level_loaded")
#	_err = events.connect("new_game", self, "_on_new_game")
#	_err = events.connect("reload_all", self, "_on_reload_all")
#	_err = events.connect("fade_finished", self, "_on_fade_finished")
#
#func _on_level_loaded() -> void:
#	self.hide()
#
#func _on_new_game() -> void:
#	self.show()
#
#func _on_reload_all() -> void:
#	self.show()
#
#func _on_fade_finished() -> void:
#	self.show()
