extends Entity

func _init():
	#TODO: add level scaling
	level = 1
	max_health = 10
	health = 10
	attack = 2
	defense = 0
	speed_inv = 0.5

func _physics_process(_delta):
	if !moving:
		direction = dir.rand_dir()
		# Grid.enemy_interact(self)
