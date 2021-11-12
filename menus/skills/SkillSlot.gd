extends PanelContainer

var skills = preload("res://menus/skills/Skills.tres")

onready var Name_Label: Label = $HBoxContainer/Name
onready var Skill_Sprite: TextureRect = $HBoxContainer/TextureRect
onready var Desc_Label: Label = $HBoxContainer/Description
onready var Skill_Button: Button = $HBoxContainer/Button

var index: int

func _ready() -> void:
	var _err = Skill_Button.connect("pressed", self, "_on_Skill_Button_pressed")
	Skill_Button.text = tr("SKILL_BUTTON")

func display_skill(skill_index: int) -> void:
	index = skill_index
	var skill: Skill = skills.skills[skill_index]
	Name_Label.text = skill.skill_name
	Desc_Label.text = skill.desc
	Skill_Sprite.texture = skill.texture

func _on_Skill_Button_pressed() -> void:
	skills.use_skill(index)
