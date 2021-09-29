extends Actor
class_name Player

var control_enabled = false
onready var Anim_Sprite = $AnimatedSprite

func _ready() -> void:
	var _err = events.connect("player_info_added", self, "_on_player_info_added")
	_err = events.connect("use_item", self, "_on_use_item")
	_err = events.connect("change_control", self, "_on_control_changed")
	
func _init() -> void:
	max_health = 10
	health = 10
	attack = 5
	defense = 0
	actor_name = tr("PLAYER_NAME")
	
func manual_init() -> void:
	set_process_unhandled_input(true)
	Anim_Sprite.hide()
	Actor_Sprite.show()
	events.emit_signal("add_allied_info", self, actor_name, Actor_Sprite.texture, "HEALTH_BAR")
	
func check_input(event: InputEvent) -> bool:
	direction = Vector2()
	if event.is_action_pressed("ui_up", true):
		direction += Vector2.UP
	if event.is_action_pressed("ui_down", true):
		direction += Vector2.DOWN
	if event.is_action_pressed("ui_left", true):
		direction += Vector2.LEFT
	if event.is_action_pressed("ui_right", true):
		direction += Vector2.RIGHT
	if event.is_action_pressed("ui_up_left", true):
		direction += dir.UP_LEFT
	if event.is_action_pressed("ui_up_right", true):
		direction += dir.UP_RIGHT
	if event.is_action_pressed("ui_down_left", true):
		direction += dir.DOWN_LEFT
	if event.is_action_pressed("ui_down_right", true):
		direction += dir.DOWN_RIGHT
	elif event.is_action_pressed("wait", true):
		return true
	
	return direction != Vector2()

func _unhandled_input(event: InputEvent) -> void:
	if check_input(event) and control_enabled:
		if Grid.interact(self): # turn ended
			set_process_unhandled_input(false)
			Grid.end_turn()
			
func _on_control_changed(status: bool) -> void:
	control_enabled = status

func _on_use_item(item: Item, item_index: int) -> void:
	item.use(self, item_index)
	events.emit_signal("item_used")
			
func _on_game_over(_current_floor: int, _enemy_name: String) -> void:
	Actor_Sprite.hide()
	Anim_Sprite.show()
	Anim_Sprite.play("dead")
	control_enabled = false
	
func _on_Grid_level_loaded() -> void:
	control_enabled = true

func _on_Grid_turn_started(current_actor: Actor) -> void:
	if not current_actor.is_in_group("enemies") and control_enabled:
		set_process_unhandled_input(true)
		
func _on_player_info_added() -> void:
	events.emit_signal("max_bar_value_changed", self, max_health)
	events.emit_signal("bar_value_changed", self, health)
	events.emit_signal("attack_changed", attack)
	events.emit_signal("defense_changed", defense)
