class_name Skill

extends Resource

var skill_name: String
var desc: String
var on_use_msg: String
var texture: Texture
var sound: int
var in_use: bool = false

func use_turn(user: Actor) -> void:
	user.Grid.end_turn()
