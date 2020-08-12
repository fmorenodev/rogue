extends Control

onready var Game_over_text = $GameOverContainer/GameOverText
onready var Game_over_subtext = $GameOverContainer/GameOverSubtext
onready var Retry_button = $GameOverContainer/Buttons/Retry
onready var Exit_button = $GameOverContainer/Buttons/Exit

func _ready():
	Game_over_text.text = tr("GAME_OVER")
	Retry_button.text = tr("RETRY")
	Exit_button.text = tr("EXIT")
	
	Retry_button.grab_focus()
	
	var _err = events.connect("game_over", self, "_on_game_over")
	_err = Retry_button.connect("pressed", self, "_on_Retry_pressed")
	_err = Exit_button.connect("pressed", self, "_on_Exit_pressed")
	
func _on_game_over(current_floor, enemy):
	Game_over_subtext.text = tr("GAME_OVER_SUBTEXT").format([current_floor, enemy])
	events.emit_signal("new_message", tr("PLAYER_DEAD"), "530000")
	self.show()

func _on_Retry_pressed():
	self.hide()
	events.emit_signal("new_game")
	events.emit_signal("build_level")

func _on_Exit_pressed():
	get_tree().change_scene("res://menus/MainMenu.tscn")
