class_name SpawnSkill

extends Skill

var turret_texture = load("res://assets/actors/turret.png")

var type: int

func add_type(skill_type: int) -> void:
	match skill_type:
		en.SPAWN_SKILL_TYPE.TURRET, _:
			type = skill_type
			texture = turret_texture
			skill_name = tr("SPAWN_SKILL").format([tr("TURRET_NAME")])
			desc = tr("SPAWN_TURRET")

func use(user: Actor) -> void:
	# choose position
	events.emit_signal("close_popups")
	events.emit_signal("ally_spawned", type)
	use_turn(user)
