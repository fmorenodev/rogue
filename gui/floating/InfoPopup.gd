extends PanelContainer

onready var Name_Label = $VBoxContainer/Name
onready var Desc_Label = $VBoxContainer/Desc

var looking: bool = false

func _ready() -> void:
	var _err = events.connect("look_at_entity", self, "_on_look")
	_err = events.connect("switch_look", self, "_on_switch_look")

func _on_look(entity: Node2D) -> void:
	Name_Label.text = ''
	Desc_Label.text = ''
	visible = true
	visible = false
	if entity != null:
		Name_Label.text = entity.entity_name.capitalize()
		Desc_Label.text = entity.desc
		visible = true
	else:
		Name_Label.text = ''
		Desc_Label.text = ''
		visible = false

func _on_switch_look() -> void:
	looking = !looking
	if Name_Label.text != '':
		visible = looking
