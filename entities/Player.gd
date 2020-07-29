extends Entity

func _ready():
	health = 10
	attack = 5
	defense = 0
	
func _physics_process(_delta):
	if !moving:
		get_input()
		if direction != Vector2():
			Grid.interact(self)
			#all other enemies / entities act
				
func get_input(): 
	direction = Vector2()
	if Input.is_action_pressed("ui_up"):
		direction += dir.up
	if Input.is_action_pressed("ui_down"):
		direction += dir.down
	if Input.is_action_pressed("ui_left"):
		direction += dir.left
	if Input.is_action_pressed("ui_right"):
		direction += dir.right

func _on_Tween_tween_completed(_object, _key):
	moving = false
