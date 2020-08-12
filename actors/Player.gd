extends Actor

func init():
	level = 1
	max_health = 10
	health = 10
	attack = 5
	defense = 0
	actor_name = tr("PLAYER_NAME")
	
	events.emit_signal("level_changed", level)
	events.emit_signal("max_health_changed", max_health)
	events.emit_signal("health_changed", health)
	events.emit_signal("attack_changed", attack)
	events.emit_signal("defense_changed", defense)
	
func check_input(event: InputEvent):
	direction = Vector2()
	if event.is_action_pressed("ui_up"):
		direction += dir.up
	elif event.is_action_pressed("ui_down"):
		direction += dir.down
	elif event.is_action_pressed("ui_left"):
		direction += dir.left
	elif event.is_action_pressed("ui_right"):
		direction += dir.right
	elif event.is_action_pressed("wait"):
		direction += dir.center
		return true
	
	return direction != Vector2()

func _unhandled_input(event: InputEvent):
	if check_input(event):
		if Grid.interact(self): # turn ended
			set_process_unhandled_input(false)
			Grid.end_turn()

func _on_Grid_turn_started(current_actor):
	if not current_actor.is_in_group("enemies"):
		set_process_unhandled_input(true)
