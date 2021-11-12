extends VBoxContainer

var skills = preload("res://menus/skills/Skills.tres")
var Skill_Slot = preload("res://menus/skills/SkillSlot.tscn")

func _ready() -> void:
	var _err = events.connect("skill_added", self, "add_slot")
	# testing
	for _i in range(0, 1):
		var new_skill = SpawnSkill.new()
		new_skill.add_type(en.ALLY_TYPE.TURRET)
		skills.add_skill(new_skill)
	for _i in range(0, 1):
		var new_skill = SpawnSkill.new()
		new_skill.add_type(en.ALLY_TYPE.HEALINGBOT)
		skills.add_skill(new_skill)
	for _i in range(0, 1):
		var new_skill = DamageSkill.new()
		new_skill.add_type(en.DAMAGE_SKILL_TYPE.BOMB)
		skills.add_skill(new_skill)
	for _i in range(0, 1):
		var new_skill = DamageSkill.new()
		new_skill.add_type(en.DAMAGE_SKILL_TYPE.SHOOT)
		skills.add_skill(new_skill) 

func add_slot(skill_index: int) -> void:
	var skill_slot = Skill_Slot.instance()
	add_child(skill_slot)
	skill_slot.display_skill(skill_index)
