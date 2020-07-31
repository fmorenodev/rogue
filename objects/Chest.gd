extends AnimatedSprite

var can_interact = true

func _init():
	#add items
	pass
	
func interact():
	play("open")
	can_interact = false
