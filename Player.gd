extends KinematicBody2D

var moving = false
onready var grid = get_parent()
onready var tile_size = grid.tile_size
onready var INTERACTION_TYPE = grid.INTERACTION_TYPE
var direction = Vector2()
var speed_inv = 0.1

func _ready():
	$AnimatedSprite.play("idle")
	pass
	
func _physics_process(_delta):
	if !moving:
		if $IdleTimer.is_stopped():
			$IdleTimer.start()
		
		get_input()
		if direction != Vector2():
			if grid.interact(self) == INTERACTION_TYPE.MOVE:
				var new_position = position + direction * tile_size
				$Tween.interpolate_property (self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				#$AnimatedSprite.stop() # here should be the moving animation
				moving = true
				$IdleTimer.stop()
				
func get_input(): 
	direction = Vector2()
	if Input.is_action_pressed("ui_up"):
		direction += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		direction += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		direction += Vector2(-1, 0)
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("ui_right"):
		direction += Vector2(1, 0)
		$AnimatedSprite.flip_h = false

func _on_Tween_tween_completed(_object, _key):
	moving = false

func _on_IdleTimer_timeout():
	$AnimatedSprite.stop()
	$AnimatedSprite.play("idle")
