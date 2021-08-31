class_name DamageSkill

extends Skill

export(int) var tile_range = 0
export(int) var damage = 0
export(int) var tile_radius = 1
export(String) var additional_effect # TODO

func use(starting_tile: Vector2, target_tile: Vector2) -> void:
	var blast_area = blast_area(target_tile, tile_radius)
	events.emit_signal("damage", blast_area)

func blast_area(center_tile: Vector2, tile_radius: int) -> PoolVector2Array:
	var tiles_affected = []
	if tile_radius < 1:
		return tiles_affected.append(center_tile)
	var area = Rect2(center_tile - Vector2(tile_radius, tile_radius), Vector2(tile_radius * 2 + 1, tile_radius * 2 + 1))
	for x in area.size.x:
		for y in area.size.y:
			tiles_affected.append(Vector2(x, y))
	return tiles_affected
