class_name Syringe

extends Item

var hs_texture = preload("res://assets/items/syringe_hs.png")
var hl_texture = preload("res://assets/items/syringe_hl.png")
var ds_texture = preload("res://assets/items/syringe_ds.png")
var dl_texture = preload("res://assets/items/syringe_dl.png")

var type: int

func add_type(syringe_type: int) -> void:
	type = syringe_type
	match type:
		en.SYRINGE_TYPE.HEALTH_S:
			texture = hs_texture
			item_name = tr("SYRINGE").format([tr("SIZE_SMALL").capitalize(), tr("EFFECT_HEALTH")])
			desc = tr("SYRINGE_HS_DESC")
		en.SYRINGE_TYPE.HEALTH_L:
			texture = hl_texture
			item_name = tr("SYRINGE").format([tr("SIZE_LARGE").capitalize(), tr("EFFECT_HEALTH")])
			desc = tr("SYRINGE_HL_DESC")
		en.SYRINGE_TYPE.DEFENSE_S:
			texture = ds_texture
			item_name = tr("SYRINGE").format([tr("SIZE_SMALL").capitalize(), tr("EFFECT_DEFENSE")])
			desc = tr("SYRINGE_DS_DESC")
		en.SYRINGE_TYPE.DEFENSE_L, _:
			texture = dl_texture
			item_name = tr("SYRINGE").format([tr("SIZE_LARGE").capitalize(), tr("EFFECT_DEFENSE")])
			desc = tr("SYRINGE_DL_DESC")

# Actor
func use(user: Node2D, item_index: int) -> void:
	match type:
		en.SYRINGE_TYPE.HEALTH_S:
			user.modify_health(5)
		en.SYRINGE_TYPE.HEALTH_L:
			user.modify_health(user.max_health)
		en.SYRINGE_TYPE.DEFENSE_S:
			user.modify_defense(2)
			# timer
		en.SYRINGE_TYPE.DEFENSE_L, _:
			user.modify_defense(4)
			# timer
	events.emit_signal("new_message", tr("ITEM_USE"), color.white, [item_name])
	inventory.change_amount(item_index, -1)
	use_turn(user)

func clone() -> Item:
	var cloned_syringe = .clone()
	cloned_syringe.type = self.type
	return cloned_syringe
