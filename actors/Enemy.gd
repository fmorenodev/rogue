class_name Enemy

extends Actor

func _on_Grid_turn_started(current_actor):
	if not current_actor.is_in_group("enemies"):
		return
	current_actor.direction = dir.rand_dir()
	Grid.enemy_interact(current_actor)
	Grid.end_turn()

func remove():
	Grid.enemies.erase(self)
	Grid.actors.erase(self)
	self.queue_free()
