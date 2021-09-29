extends VBoxContainer

var skills = preload("res://menus/skills/Skills.tres")

func _ready() -> void:
	skills.add_skill()
