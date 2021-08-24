extends HBoxContainer

onready var Button = $Button
onready var Selector = $Selector

func _ready() -> void:
	var _err = Button.connect("focus_entered", self, "_on_Button_focus_entered")
	_err = Button.connect("focus_exited", self, "_on_Button_focus_exited")

func _on_Button_focus_entered() -> void:
	Selector.show()

func _on_Button_focus_exited() -> void:
	Selector.hide()
