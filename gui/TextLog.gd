extends Panel

onready var Text_box = $TextBox
onready var font = Text_box.get_font("normal_font")
onready var window_size = Text_box.get_size()
var max_lines

var level_entered_text: String = tr("LEVEL_ENTERED")

func _ready():
	var _err = events.connect("new_message", self, "on_new_message")
	_err = events.connect("build_level", self, "on_Map_build_level")
	add_placeholder_spaces()

func add_placeholder_spaces():
	Text_box.clear()
	var font_height = font.get_height()
	max_lines = window_size[1] / font_height
	for line in max_lines:
		Text_box.newline()
	
func on_new_message(text):
	Text_box.newline()
	Text_box.append_bbcode(text)

func on_Map_build_level():
	Text_box.newline()
	Text_box.append_bbcode("[color=#fcba03]%s[/color]" % level_entered_text)
