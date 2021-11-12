class_name SpawnSkill

extends Skill

var turret_texture = load("res://assets/actors/turret.png")
var healingbot_texture = load("res://assets/actors/healing_bot.png")

var type: int
var tile_range: int = 1

func _init() -> void:
	var _err = events.connect("target_chosen", self, "_on_target_chosen")
	_err = events.connect("targets_calculated", self, "_on_targets_calculated")

func add_type(skill_type: int) -> void:
	match skill_type:
		en.ALLY_TYPE.TURRET:
			type = skill_type
			texture = turret_texture
			skill_name = tr("SPAWN_SKILL").format([tr("TURRET_NAME")])
			desc = tr("SPAWN_TURRET")
		en.ALLY_TYPE.HEALINGBOT, _:
			type = skill_type
			texture = healingbot_texture
			skill_name = tr("SPAWN_SKILL").format([tr("HEALINGBOT_NAME")])
			desc = tr("SPAWN_HEALINGBOT")
	on_use_msg = tr("SPAWN_ON_USE")

func use(user: Actor) -> void:
	in_use = true
	events.emit_signal("calc_targets", user.position, tile_range, false)
	
func _on_targets_calculated(targets: PoolVector2Array) -> void:
	if !targets.empty() && in_use:
		events.emit_signal("switch_target", targets)
		events.emit_signal("close_popups")
	else:
		in_use = false

func _on_target_chosen(user: Actor, pos: Vector2) -> void:
	if pos == null:
		in_use = false
		events.emit_signal("open_skills")
	elif in_use:
		events.emit_signal("new_message", on_use_msg, color.cyan)
		events.emit_signal("ally_spawned", type, pos)
		# animation and sound
		use_turn(user)
		in_use = false
