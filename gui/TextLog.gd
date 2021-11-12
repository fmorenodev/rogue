extends Panel

onready var Text_box = $TextBox
onready var font = Text_box.get_font("normal_font")
onready var font_color = font.outline_color.to_html()
onready var window_size = Text_box.get_size()

var level_entered_text = tr("LEVEL_ENTERED")

func _ready() -> void:
	var _err = events.connect("new_message", self, "_on_new_message")
	_err = events.connect("new_message_no_newline", self, "_on_new_message_no_newline")
	Text_box.clear()

func _on_new_message(text: String, color: String = font_color, args: Array = []) -> void:
	Text_box.newline()
	_on_new_message_no_newline(text, color, args)

func _on_new_message_no_newline(text: String, color: String = font_color, args: Array = []) -> void:
	var formatted_text = text.format(args)
	Text_box.append_bbcode("[color=#" + color + "]%s[/color]" % formatted_text)
