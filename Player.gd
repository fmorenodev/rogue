extends KinematicBody2D

var moving = false
onready var tile_size = 32 #16 * $AnimatedSprite.scale

func _ready():
	$AnimatedSprite.play("idle")
	pass
	
func _physics_process(_delta):
	if !moving:
		if $IdleTimer.is_stopped():
			$IdleTimer.start()
		
		var motion_vector = get_input()
		if motion_vector != Vector2():
			#tile_size is the size of the tilemap in pixels.
			var new_position = position + motion_vector * tile_size
			if not test_move(global_transform, motion_vector):
				#Yes. I'm assuming you have a Tween node as a child.
				$Tween.interpolate_property ( self, 'position', position, new_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				#That last method's fifth property is how long it takes to go from one tile to the other in seconds.
				$Tween.start()
				$AnimatedSprite.play("move")
				moving = true
				$IdleTimer.stop()
				
func get_input(): 
	var motion_vector = Vector2()
	if Input.is_action_pressed("ui_up"):
		motion_vector += Vector2( 0, -1)
	elif Input.is_action_pressed("ui_down"):
		motion_vector += Vector2( 0, 1)
	elif Input.is_action_pressed("ui_left"):
		motion_vector += Vector2( -1, 0)
		$AnimatedSprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		motion_vector += Vector2( 1, 0)
		$AnimatedSprite.flip_h = false

func _on_Tween_tween_completed(_object, _key):
	moving = false

func _on_IdleTimer_timeout():
	$AnimatedSprite.stop()
	$AnimatedSprite.play("idle")
