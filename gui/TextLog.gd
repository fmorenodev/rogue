extends Panel

onready var Text_box = $TextBox
onready var font = Text_box.get_font("normal_font")
onready var font_color = font.outline_color.to_html()
onready var window_size = Text_box.get_size()

var level_entered_text: String = tr("LEVEL_ENTERED")

func _ready():
	var _err = events.connect("new_message", self, "_on_new_message")
	_err = events.connect("new_game_cleanup", self, "_on_new_game_cleanup")
	Text_box.clear()
	
func _on_new_message(text, color = font_color, args = []):
	var formatted_text = text.format(args)
	Text_box.newline()
	Text_box.append_bbcode("[color=#" + color + "]%s[/color]" % formatted_text)

func _on_new_game_cleanup():
	Text_box.clear()
	events.emit_signal("new_game")
	pass
