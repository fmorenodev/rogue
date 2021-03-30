extends Actor

var control_enabled = false
onready var Anim_Sprite = $AnimatedSprite

func _ready():
	var _err = events.connect("player_info_added", self, "_on_player_info_added")
	
func init():
	level = 1
	max_health = 10
	health = 10
	attack = 5
	defense = 0
	actor_name = tr("PLAYER_NAME")
	control_enabled = false
	set_process_unhandled_input(true)
	#Actor_Sprite.play("idle")
	Anim_Sprite.hide()
	Actor_Sprite.show()
	events.emit_signal("add_allied_info", self, actor_name, Actor_Sprite.texture, "HEALTH_BAR")
	
func check_input(event: InputEvent):
	direction = Vector2()
	if event.is_action_pressed("ui_up"):
		direction += dir.up
	if event.is_action_pressed("ui_down"):
		direction += dir.down
	if event.is_action_pressed("ui_left"):
		direction += dir.left
	if event.is_action_pressed("ui_right"):
		direction += dir.right
	if event.is_action_pressed("wait"):
		direction += dir.center
		return true
	
	return direction != Vector2()

func _unhandled_input(event: InputEvent):
	if check_input(event) and control_enabled:
		if Grid.interact(self): # turn ended
			set_process_unhandled_input(false)
			Grid.end_turn()
			
func _on_game_over(_current_floor, _enemy):
	Actor_Sprite.hide()
	Anim_Sprite.show()
	Anim_Sprite.play("dead")
	control_enabled = false
	
func _on_Grid_level_loaded():
	control_enabled = true

func _on_Grid_turn_started(current_actor):
	if not current_actor.is_in_group("enemies") and control_enabled:
		set_process_unhandled_input(true)
		
func _on_player_info_added():
	events.emit_signal("level_changed", actor_name, level)
	events.emit_signal("max_bar_value_changed", self, max_health)
	events.emit_signal("bar_value_changed", self, health)
	events.emit_signal("attack_changed", attack)
	events.emit_signal("defense_changed", defense)
