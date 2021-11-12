class_name DamageSkill

extends Skill

var shot_texture = load("res://assets/skills/bullet.png")
var bomb_texture = load("res://assets/skills/bomb.png")

var tile_range: int = 0
var damage: int = 0
var tile_radius: int = 0
var additional_effect: Dictionary

func _init() -> void:
	var _err = events.connect("target_chosen", self, "_on_target_chosen")
	_err = events.connect("targets_calculated", self, "_on_targets_calculated")

func add_type(skill_type: int) -> void:
	match skill_type:
		en.DAMAGE_SKILL_TYPE.SHOOT:
			texture = shot_texture
			tile_range = 4
			damage = 5
			skill_name = tr("SHOOT_SKILL")
			desc = tr("SHOOT_DESC")
			on_use_msg = tr("SHOOT_ON_USE")
		en.DAMAGE_SKILL_TYPE.BOMB:
			texture = bomb_texture
			tile_range = 4
			damage = 5
			tile_radius = 2
			skill_name = tr("BOMB_SKILL")
			desc = tr("BOMB_DESC")
			on_use_msg = tr("BOMB_ON_USE")

func use(user: Actor) -> void:
	in_use = true
	events.emit_signal("calc_targets", user.position, tile_range, true)
	
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
		var blast_area = data.calc_area(pos, tile_radius)
		events.emit_signal("new_message", on_use_msg, color.white, [user.entity_name])
		events.emit_signal("area_effect", blast_area, {"damage": damage}) # additional effects added as k/v
		# animation and sound
		use_turn(user)
		in_use = false
