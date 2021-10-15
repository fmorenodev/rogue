class_name Enemy

extends Actor

onready var Map = get_node("../../")
onready var Player = get_node("../Player")

func _ready() -> void:
	var _err = events.connect("enemy_info_added", self, "_on_info_added")
	
func manual_init() -> void:
	events.emit_signal("add_actor_info", self, actor_name, Actor_Sprite.texture, "HEALTH_BAR")

func _on_Grid_turn_started(current_actor: Actor) -> void:
	if not current_actor.is_in_group("enemies"):
		return
	# check enemy type for different ai?
	current_actor.direction = Map.find_step(current_actor.position, Player.position)
	Grid.enemy_interact(current_actor)
	Grid.end_turn()

func remove() -> void:
	Grid.enemies.erase(self)
	Grid.actors.erase(self)
	events.emit_signal("actor_removed", self)
	self.queue_free()

func _on_info_added(info_node: ActorInfo) -> void:
	if !events.is_connected("actor_removed", info_node, "_on_Actor_removed"):
		var _err = events.connect("actor_removed", info_node, "_on_Actor_removed")
	events.emit_signal("max_bar_value_changed", self, max_health)
	events.emit_signal("bar_value_changed", self, health)
