extends AnimatedSprite

var can_interact = true
var interaction = "CHEST_OPEN"
var args = ["placeholder"]

func _init():
	#add items
	pass
	
func interact():
	play("open")
	can_interact = false
