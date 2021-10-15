class_name Ally

extends Actor

onready var Map = get_node("../../")
onready var Player = get_node("../Player")

func _ready() -> void:
	var _err = events.connect("allied_info_added", self, "_on_allied_info_added")

func manual_init() -> void:
	events.emit_signal("add_allied_info", self, actor_name, Actor_Sprite.texture, "HEALTH_BAR")
	
func _on_Grid_turn_started(current_actor: Actor) -> void:
	if not current_actor.is_in_group("allies"):
		return
	Grid.end_turn()

func remove() -> void:
	Grid.enemies.erase(self)
	Grid.actors.erase(self)
	events.emit_signal("actor_removed", self)
	self.queue_free()

func _on_allied_info_added(info_node: ActorInfo) -> void:
	if self.is_in_group("allies") and !events.is_connected("actor_removed", info_node, "_on_Actor_removed"):
		var _err = events.connect("actor_removed", info_node, "_on_Actor_removed")
	events.emit_signal("max_bar_value_changed", self, max_health)
	events.emit_signal("bar_value_changed", self, health)
	events.emit_signal("attack_changed", attack)
	events.emit_signal("defense_changed", defense)
