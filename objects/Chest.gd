extends E_Object

func _init():
	object_name = tr("CHEST")
	interaction = tr("CHEST_OPEN")
	can_interact = true
	#add items
	pass
	
func interact():
	#play("open")
	can_interact = false
