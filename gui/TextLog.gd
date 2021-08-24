extends Panel

onready var Text_box = $TextBox
onready var font = Text_box.get_font("normal_font")
onready var font_color = font.outline_color.to_html()
onready var window_size = Text_box.get_size()

var level_entered_text = tr("LEVEL_ENTERED")

func _ready() -> void:
	var _err = events.connect("new_message", self, "_on_new_message")
	Text_box.clear()
	
func _on_new_message(text: String, color: String = font_color, args: Array = []) -> void:
	var formatted_text = text.format(args)
	Text_box.newline()
	Text_box.append_bbcode("[color=#" + color + "]%s[/color]" % formatted_text)
