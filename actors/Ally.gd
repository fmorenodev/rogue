class_name Ally

extends Actor

onready var Map = get_node("../../")
onready var turret_texture = preload("res://assets/actors/turret.png")
onready var healingbot_texture = preload("res://assets/actors/healing_bot.png")

func _ready() -> void:
	var _err = events.connect("allied_info_added", self, "_on_allied_info_added")

func manual_init() -> void:
	events.emit_signal("add_allied_info", self, entity_name, Actor_Sprite.texture, "HEALTH_BAR")
	
func add_type(ally_type: int) -> void:
	type = ally_type
	match type:
		en.ALLY_TYPE.TURRET:
			max_health = 10
			health = 10
			attack = 2
			defense = 0
			entity_name = tr("TURRET_NAME")
			desc = tr("TURRET_DESC")
			Actor_Sprite.texture = turret_texture
		en.ALLY_TYPE.HEALINGBOT, _:
			max_health = 4
			health = 4
			attack = 0
			defense = 0
			entity_name = tr("HEALINGBOT_NAME")
			desc = tr("HEALINGBOT_DESC")
			Actor_Sprite.texture = healingbot_texture

func _on_Grid_turn_started(current_actor: Actor) -> void:
	if not current_actor.is_in_group("allies"):
		return
	match current_actor.type:
		en.ALLY_TYPE.TURRET:
			#shoot
			pass
		en.ALLY_TYPE.HEALINGBOT, _:
			# follow and heal
			pass
	if Grid.Anim_Player.is_playing():
		events.emit_signal("switch_input", false)
		yield(Grid.Anim_Player, "animation_finished")
		events.emit_signal("switch_input", true)
	Grid.end_turn()

func remove() -> void:
	.remove()
	Grid.allies.erase(self)
	#Grid.actors.erase(self)
	#data.entities.erase(self)
	events.emit_signal("ally_removed", self)
	self.queue_free()

func _on_allied_info_added(info_node: AlliedInfo) -> void:
	if self.is_in_group("allies") and !events.is_connected("ally_removed", info_node, "_on_Ally_removed"):
		var _err = events.connect("ally_removed", info_node, "_on_Ally_removed")
	events.emit_signal("max_bar_value_changed", self, max_health)
	events.emit_signal("bar_value_changed", self, health)
	events.emit_signal("attack_changed", self, attack)
	events.emit_signal("defense_changed", self, defense) 
