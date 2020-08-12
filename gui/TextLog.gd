extends Panel

onready var Text_box = $TextBox
onready var font = Text_box.get_font("normal_font")
onready var font_color = font.outline_color.to_html()
onready var window_size = Text_box.get_size()

var level_entered_text: String = tr("LEVEL_ENTERED")

func _ready():
	var _err = events.connect("new_message", self, "_on_new_message")
	_err = events.connect("new_message_newline", self, "_on_new_message_newline")
	_err = events.connect("new_game", self, "_on_new_game")
	Text_box.clear()
	
func _on_new_message(text, color = font_color, args = []):
	var formatted_text = text.format(args)
	Text_box.newline()
	Text_box.append_bbcode("[color=#" + color + "]%s[/color]" % formatted_text)

func _on_new_message_newline(text, color = font_color, args = []):
	Text_box.newline()
	_on_new_message(text, color, args)

func _on_new_game():
	Text_box.clear()
