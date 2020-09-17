extends Control

onready var Game_Over_Text_1 = $GameOverContainer/GameOverTitle/GameOverText1
onready var Game_Over_Text_2 = $GameOverContainer/GameOverTitle/GameOverText2
onready var Game_Over_Subtext = $GameOverContainer/GameOverSubtext
onready var Retry_Button = $GameOverContainer/Buttons/Retry/Button
onready var Retry_Selector = $GameOverContainer/Buttons/Retry/Selector
onready var Exit_Button = $GameOverContainer/Buttons/Exit/Button
onready var Anim_Player = $AnimationPlayer

func _ready():
	Game_Over_Text_1.text = tr("GAME_OVER_1")
	Game_Over_Text_2.text = tr("GAME_OVER_2")
	Retry_Button.text = tr("RETRY")
	Exit_Button.text = tr("EXIT")
	
	Retry_Selector.show()
	
	var _err = events.connect("game_over", self, "_on_game_over")
	_err = Retry_Button.connect("pressed", self, "_on_Retry_pressed")
	_err = Exit_Button.connect("pressed", self, "_on_Exit_pressed")
	_err = Anim_Player.connect("animation_finished", self, "_on_animation_finished")
	
func _on_game_over(current_floor, enemy):
	Game_Over_Subtext.text = tr("GAME_OVER_SUBTEXT").format([current_floor, enemy])
	events.emit_signal("new_message", tr("PLAYER_DEAD"), color.dark_red)
	self.show()
	Anim_Player.play("init") # continued in _on_animation_finished

func _on_Retry_pressed():
	self.hide()
	events.emit_signal("new_game_cleanup")
	events.emit_signal("build_level")

func _on_Exit_pressed():
	var _err = get_tree().change_scene("res://menus/MainMenu.tscn")

func _on_animation_finished(anim_name):
	if anim_name == "init":
		Anim_Player.play("game_over")
	elif anim_name == "game_over":
		Retry_Button.grab_focus()
