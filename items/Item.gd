class_name Item

extends AnimatedSprite

onready var Grid = get_parent()

func pick_up(owner):
	#add to inventory
	self.queue_free()
	Grid.items.erase(self)
