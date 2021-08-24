extends E_Object

func _init() -> void:
	object_name = tr("CHEST")
	interaction = tr("CHEST_OPEN")
	can_interact = true
	#add items
	pass
	
func interact() -> void:
	play("open")
	events.emit_signal("sprite_changed", self, self.frames.get_frame("open", 4))
	# pass items to player
	can_interact = false
