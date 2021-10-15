class_name DamageSkill

extends Skill

var shot_texture = load("res://assets/skills/bullet.png")
var bomb_texture = load("res://assets/skills/bomb.png")

export(int) var tile_range = 0
export(int) var damage = 0
export(int) var tile_radius = 1
export(String) var additional_effect # TODO

func add_type(skill_type: int) -> void:
	match skill_type:
		en.DAMAGE_SKILL_TYPE.SHOOT:
			texture = shot_texture
			tile_range = 4
			damage = 5
			skill_name = tr("SHOOT_SKILL")
			desc = tr("SHOOT_DESC")
		en.DAMAGE_SKILL_TYPE.BOMB:
			texture = bomb_texture
			tile_range = 4
			damage = 5
			tile_radius = 2
			skill_name = tr("BOMB_SKILL")
			desc = tr("BOMB_DESC")

func use(user: Actor) -> void:
	# target_tile is calculated using the targeting system
	# calculate actual reach with user_position to target_tile ?
	# var blast_area = calc_blast_area(target_tile)
	# events.emit_signal("damage", blast_area)
	pass

func calc_blast_area(center_tile: Vector2) -> PoolVector2Array:
	var tiles_affected = []
	if tile_radius < 1:
		return tiles_affected.append(center_tile)
	var area = Rect2(center_tile - Vector2(tile_radius, tile_radius), Vector2(tile_radius * 2 + 1, tile_radius * 2 + 1))
	for x in area.size.x:
		for y in area.size.y:
			tiles_affected.append(Vector2(x, y))
	return tiles_affected
