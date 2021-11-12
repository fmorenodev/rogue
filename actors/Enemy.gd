class_name Enemy

extends Actor

onready var Map = get_node("../../")
onready var Player = get_node("../Player")
onready var bombling_texture = preload("res://assets/actors/bombling.png")
onready var cybertemplar_texture = preload("res://assets/actors/cyber_templar.png")
onready var shieldbot_texture = preload("res://assets/actors/shield_bot.png")
onready var zombie_texture = preload("res://assets/actors/zombie.png")
onready var scratch = preload("res://assets/sounds/scratch.wav")

func _ready() -> void:
	var _err = events.connect("enemy_info_added", self, "_on_info_added")
	
func manual_init() -> void:
	events.emit_signal("add_actor_info", self, entity_name, Actor_Sprite.texture, "HEALTH_BAR")

func add_type(enemy_type: int) -> void:
	type = enemy_type
	match type:
		en.ENEMY_TYPE.BOMBLING:
			max_health = 10
			health = 10
			attack = 2
			defense = 0
			entity_name = tr("BOMBLING_NAME")
			desc = tr("BOMBLING_DESC")
			Actor_Sprite.texture = bombling_texture
			attack_sound = scratch
		en.ENEMY_TYPE.CYBERTEMPLAR:
			max_health = 10
			health = 10
			attack = 2
			defense = 0
			entity_name = tr("CYBERTEMPLAR_NAME")
			desc = tr("CYBERTEMPLAR_DESC")
			Actor_Sprite.texture = cybertemplar_texture
		en.ENEMY_TYPE.SHIELDBOT:
			max_health = 10
			health = 10
			attack = 0
			defense = 1
			entity_name = tr("SHIELDBOT_NAME")
			desc = tr("SHIELDBOT_DESC")
			Actor_Sprite.texture = shieldbot_texture
		en.ENEMY_TYPE.ZOMBIE, _:
			max_health = 10
			health = 10
			attack = 2
			defense = 0
			entity_name = tr("ZOMBIE_NAME")
			desc = tr("ZOMBIE_DESC")
			Actor_Sprite.texture = zombie_texture
			attack_sound = scratch

func _on_Grid_turn_started(current_actor: Actor) -> void:
	if not current_actor.is_in_group("enemies"):
		return

	match current_actor.type:
		en.ENEMY_TYPE.CYBERTEMPLAR:
			#move or shoot if in range
			pass
		en.ENEMY_TYPE.SHIELDBOT:
			#block or protect
			pass
		_:
			#pursuit
			current_actor.direction = Map.find_step(current_actor.position, Player.position)
			
	Grid.enemy_interact(current_actor)
	if Grid.Anim_Player.is_playing():
		events.emit_signal("switch_input", false)
		yield(Grid.Anim_Player, "animation_finished")
		events.emit_signal("switch_input", true)
	Grid.end_turn()

func remove() -> void:
	.remove()
	Grid.enemies.erase(self)
	#Grid.actors.erase(self)
	#data.entities.erase(self)
	events.emit_signal("actor_removed", self)
	self.queue_free()

func _on_info_added(info_node: ActorInfo) -> void:
	if !events.is_connected("actor_removed", info_node, "_on_Actor_removed"):
		var _err = events.connect("actor_removed", info_node, "_on_Actor_removed")
	events.emit_signal("max_bar_value_changed", self, max_health)
	events.emit_signal("bar_value_changed", self, health)
