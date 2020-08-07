class_name Actor

extends KinematicBody2D

onready var Grid = get_parent()
onready var tile_size = Grid.tile_size
var direction = Vector2()

var level = 1
var status = en.STATUS.ALIVE
var max_health
var health
var attack
var defense
var actor_name

func move():
	if direction == dir.left:
		$AnimatedSprite.flip_h = true
	elif direction == dir.right:
		$AnimatedSprite.flip_h = false
	var new_position = position + direction * tile_size
	position = new_position

func take_damage(attack_value):
	var damage = attack_value - defense #* modifier
	health = max(0, health - damage)
	
	if has_method("check_input"):
		events.emit_signal("health_changed", health)
	
	if health == 0:
		if has_method("check_input"):
			#gameover
			pass
		else:
			status = en.STATUS.DEAD

	return damage
