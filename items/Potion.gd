class_name Potion

extends Item

var hs_texture = preload("res://assets/2D Pixel Dungeon Asset Pack/item_animation/flasks/flasks_1_1.png")
var hl_texture = preload("res://assets/2D Pixel Dungeon Asset Pack/item_animation/flasks/flasks_4_1.png")
var ds_texture = preload("res://assets/2D Pixel Dungeon Asset Pack/item_animation/flasks/flasks_2_1.png")
var dl_texture = preload("res://assets/2D Pixel Dungeon Asset Pack/item_animation/flasks/flasks_3_1.png")

var type: int

func add_type(_type) -> void:
	type = _type
	item_name = tr("POTION").format([str(type)]) # update when items get more functionality
	match type:
		en.POTION_TYPE.HEALTH_S:
			texture = hs_texture
			item_name = tr("POTION").format([tr("SIZE_SMALL").capitalize(), tr("EFFECT_HEALTH")])
			desc = tr("POTION_S_HEALTH_DESC")
		en.POTION_TYPE.HEALTH_L:
			texture = hl_texture
			item_name = tr("POTION").format([tr("SIZE_LARGE").capitalize(), tr("EFFECT_HEALTH")])
			desc = tr("POTION_L_HEALTH_DESC")
		en.POTION_TYPE.DEFENSE_S:
			texture = ds_texture
			item_name = tr("POTION").format([tr("SIZE_SMALL").capitalize(), tr("EFFECT_DEFENSE")])
			desc = tr("POTION_S_DEF_DESC")
		en.POTION_TYPE.DEFENSE_L:
			texture = dl_texture
			item_name = tr("POTION").format([tr("SIZE_LARGE").capitalize(), tr("EFFECT_DEFENSE")])
			desc = tr("POTION_L_DEF_DESC")

# Actor
func use(user: Node2D, item_index: int) -> void:
	match type:
		en.POTION_TYPE.HEALTH_S:
			user.modify_health(5)
		en.POTION_TYPE.HEALTH_L:
			user.modify_health(user.max_health)
		en.POTION_TYPE.DEFENSE_S:
			user.modify_defense(2)
			# timer
		en.POTION_TYPE.DEFENSE_L:
			user.modify_defense(4)
			# timer
	events.emit_signal("new_message", tr("POTION_DRINK"), color.white, [item_name])
	inventory.change_amount(item_index, -1)
	use_turn(user)
	
func clone() -> Item:
	var cloned_potion = .clone()
	cloned_potion.type = self.type
	return cloned_potion
