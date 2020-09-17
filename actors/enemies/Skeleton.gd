extends Enemy

func _init():
	#TODO: add level scaling
	level = 1
	max_health = 10
	health = 10
	attack = 10
	defense = 0
	actor_name = tr("SKELETON_NAME")
