extends AnimatedSprite

enum TYPE {HEALTH_S, HEALTH_L, DEFENSE_S, DEFENSE_L}
var type
onready var Grid = get_parent()

func init(_type):
	type = _type
	match type:
		TYPE.HEALTH_S:
			play("health_s")
		TYPE.HEALTH_L:
			play("health_l")
		TYPE.DEFENSE_S:
			play("defense_s")
		TYPE.DEFENSE_L:
			play("defense_l")
			
func use(user):
	match type:
		TYPE.HEALTH_S:
			user.health += 5
		TYPE.HEALTH_L:
			user.health += user.max_health
		TYPE.DEFENSE_S:
			user.defense += 2
			# timer
		TYPE.DEFENSE_L:
			user.defense += 4
			# timer
			
func pick_up(owner):	
	#owner.add_to_inventory(self)
	pass
	
func remove():
	self.queue_free()
	Grid.items.erase(self)
