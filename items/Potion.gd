extends Item

var hs_texture = preload("res://assets/2D Pixel Dungeon Asset Pack/item_animation/flasks/flasks_1_1.png")
var hl_texture = preload("res://assets/2D Pixel Dungeon Asset Pack/item_animation/flasks/flasks_4_1.png")
var ds_texture = preload("res://assets/2D Pixel Dungeon Asset Pack/item_animation/flasks/flasks_2_1.png")
var dl_texture = preload("res://assets/2D Pixel Dungeon Asset Pack/item_animation/flasks/flasks_3_1.png")

var type

func add_type(_type):
	type = _type
	item_name = tr("POTION").format([str(type)]) # update when items get more functionality
	match type:
		en.POTION_TYPE.HEALTH_S:
			texture = hs_texture
			item_name = tr("POTION").format([tr("SIZE_SMALL").capitalize(), tr("EFFECT_HEALTH")])
		en.POTION_TYPE.HEALTH_L:
			texture = hl_texture
			item_name = tr("POTION").format([tr("SIZE_LARGE").capitalize(), tr("EFFECT_HEALTH")])
		en.POTION_TYPE.DEFENSE_S:
			texture = ds_texture
			item_name = tr("POTION").format([tr("SIZE_SMALL").capitalize(), tr("EFFECT_DEFENSE")])
		en.POTION_TYPE.DEFENSE_L:
			texture = dl_texture
			item_name = tr("POTION").format([tr("SIZE_LARGE").capitalize(), tr("EFFECT_DEFENSE")])
			
func use(user):
	match type:
		en.POTION_TYPE.HEALTH_S:
			user.health += user.max_health /2
		en.POTION_TYPE.HEALTH_L:
			user.health += user.max_health
		en.POTION_TYPE.DEFENSE_S:
			user.defense += 2
			# timer
		en.POTION_TYPE.DEFENSE_L:
			user.defense += 4
			# timer
			
func remove():
	self.queue_free()
	Grid.items.erase(self)
