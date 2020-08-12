extends Control

var version = "0.0.1"
onready var New_Game_Button = $MenuContainer/Buttons/NewGame
onready var Continue_Button = $MenuContainer/Buttons/Continue
onready var Options_Button = $MenuContainer/Buttons/Options
onready var Version_Label = $MenuContainer/Info/Version
onready var Dev_Label = $MenuContainer/Info/Dev

func _ready():
	New_Game_Button.text = tr("NEW_GAME")
	Continue_Button.text = tr("CONTINUE")
	Options_Button.text = tr("OPTIONS")
	Version_Label.text = tr("GAME_VERSION").format([version])
	Dev_Label.text = tr("GAME_DEV")
	
	New_Game_Button.grab_focus()
	
	var _err = New_Game_Button.connect("pressed", self, "_on_New_Game_pressed")
	_err = Continue_Button.connect("pressed", self, "_on_Continue_pressed")
	_err = Options_Button.connect("pressed", self, "_on_Options_pressed")

func _on_New_Game_pressed():
	get_tree().change_scene("res://engine/Main.tscn")

func _on_Continue_pressed():
	pass
	
func _on_Options_pressed():
	pass
