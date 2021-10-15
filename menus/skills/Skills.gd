class_name Skills

extends Resource

var skills = []

func add_skill(skill: Skill) -> void:
	skills.append(skill)
	events.emit_signal("skill_added", skills.size() - 1)
	
func remove_skill(skill_index: int) -> Skill:
	var removed_skill = skills[skill_index]
	skills.remove(skill_index)
	events.emit_signal("skill_removed", skill_index)
	return removed_skill
	
func use_skill(skill_index: int) -> void:
	var skill = skills[skill_index]
	events.emit_signal("use_skill", skill)
