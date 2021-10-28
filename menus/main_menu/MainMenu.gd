extends Control

var scene_path: String
var version = "0.0.1"
onready var Title = $MenuContainer/Title
onready var New_Game_Button = $MenuContainer/Buttons/NewGame/Button
onready var Continue_Button = $MenuContainer/Buttons/Continue/Button
onready var Options_Button = $MenuContainer/Buttons/Options/Button
onready var New_Game_Selector = $MenuContainer/Buttons/NewGame/Selector
onready var Version_Label = $MenuContainer/Info/Version
onready var Dev_Label = $MenuContainer/Info/Dev
onready var Fade_In = $FadeIn

func _ready() -> void:
	Title.text = tr("GAME_TITLE")
	New_Game_Button.text = tr("NEW_GAME")
	Continue_Button.text = tr("CONTINUE")
	Options_Button.text = tr("OPTIONS")
	Version_Label.text = tr("GAME_VERSION").format([version])
	Dev_Label.text = tr("GAME_DEV")
	
	New_Game_Button.grab_focus()

	New_Game_Selector.show()
	
	var _err = New_Game_Button.connect("pressed", self, "_on_NewGame_pressed")
	_err = Continue_Button.connect("pressed", self, "_on_Continue_pressed")
	_err = Options_Button.connect("pressed", self, "_on_Options_pressed")
	_err = events.connect("fade_finished", self, "_on_FadeIn_fade_finished")

func _on_NewGame_pressed() -> void:
	scene_path = "res://engine/Main.tscn"
	Fade_In.show()
	Fade_In.fade_in()

func _on_Continue_pressed() -> void:
	pass
	
func _on_Options_pressed() -> void:
	pass
	
func _on_FadeIn_fade_finished() -> void:
	var _err = get_tree().change_scene(scene_path)
