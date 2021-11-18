extends HBoxContainer

onready var Button = $Button
onready var Selector = $Selector

func _ready() -> void:
	var _err = Button.connect("focus_entered", self, "_on_Button_focus_entered")
	_err = Button.connect("focus_exited", self, "_on_Button_focus_exited")
	_err = Button.connect("button_down", self, "_on_Button_pressed")

func _on_Button_focus_entered() -> void:
	events.emit_signal("play_sound", en.SOUNDS.MENU_MOVE)
	Selector.show()

func _on_Button_focus_exited() -> void:
	Selector.hide()

func _on_Button_pressed() -> void:
	events.emit_signal("play_sound", en.SOUNDS.MENU_PRESS)
