extends Control

onready var Game_Over_Text_1 = $GameOverContainer/GameOverTitle/GameOverText1
onready var Game_Over_Text_2 = $GameOverContainer/GameOverTitle/GameOverText2
onready var Game_Over_Subtext = $GameOverContainer/GameOverSubtext
onready var Retry_Button = $GameOverContainer/Buttons/Retry/Button
onready var Retry_Selector = $GameOverContainer/Buttons/Retry/Selector
onready var Exit_Button = $GameOverContainer/Buttons/Exit/Button
onready var Anim_Player = $AnimationPlayer

func _ready() -> void:
	Game_Over_Text_1.text = tr("GAME_OVER_1")
	Game_Over_Text_2.text = tr("GAME_OVER_2")
	Retry_Button.text = tr("RETRY")
	Exit_Button.text = tr("EXIT")
	
	Retry_Selector.show()
	
	var _err = events.connect("game_over", self, "_on_game_over")
	_err = Retry_Button.connect("pressed", self, "_on_Retry_pressed")
	_err = Exit_Button.connect("pressed", self, "_on_Exit_pressed")
	_err = Anim_Player.connect("animation_finished", self, "_on_animation_finished")

func _on_game_over(current_floor: int, enemy_name: String) -> void:
	events.emit_signal("play_music", en.MUSIC.GAME_OVER_INTRO)
	Game_Over_Subtext.text = tr("GAME_OVER_SUBTEXT").format([current_floor, enemy_name])
	events.emit_signal("new_message", tr("ACTOR_DEAD"), color.dark_red, [tr("PLAYER_NAME")])
	self.show()
	Anim_Player.play("game_over") # continued in _on_animation_finished

func _on_Retry_pressed() -> void:
	self.hide()
	events.emit_signal("reload_all")

func _on_Exit_pressed() -> void:
	var _err = get_tree().change_scene("res://menus/main_menu/MainMenu.tscn")

func _on_animation_finished(_anim_name: String) -> void:
	Retry_Button.grab_focus()
