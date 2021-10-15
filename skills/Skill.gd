class_name Skill

extends Resource

var skill_name: String
var desc: String
var texture: Texture

func use_turn(user: Actor) -> void:
	user.Grid.end_turn()
