extends Actor

func _ready():
	max_health = 10
	health = 10
	attack = 5
	defense = 0
	
#func _physics_process(_delta):
#	if !moving:
#		get_input()
#		if direction != Vector2():
#			Grid.interact(self)
#			#all other enemies / entities act
	
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
	
	return direction != Vector2()

func _unhandled_input(event: InputEvent):
	if check_input(event):
		if Grid.interact(self): # turn ended
			set_process_unhandled_input(false)
			Grid.end_turn()

func _on_Grid_turn_started(current_actor):
	if not current_actor.is_in_group("enemies"):
		set_process_unhandled_input(true)
