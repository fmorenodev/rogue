class_name Enemy

extends Actor

func _ready():
	events.emit_signal("add_actor_info", self, actor_name, Actor_Sprite, "HEALTH_BAR")
	var _err = events.connect("enemy_info_added", self, "_on_info_added")

func _on_Grid_turn_started(current_actor):
	if not current_actor.is_in_group("enemies"):
		return
	current_actor.direction = dir.rand_dir()
	Grid.enemy_interact(current_actor)
	Grid.end_turn()

func remove():
	Grid.enemies.erase(self)
	Grid.actors.erase(self)
	events.emit_signal("actor_removed", self)
	self.queue_free()

func _on_info_added(enemy_node, info_node):
	var _err = events.connect("actor_removed", info_node, "_on_Actor_removed")
	events.emit_signal("max_bar_value_changed", self, max_health)
	events.emit_signal("bar_value_changed", self, health)
