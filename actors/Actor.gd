class_name Actor

extends KinematicBody2D

onready var Grid = get_parent()
onready var Actor_Sprite = $Sprite
var direction = Vector2()

var level = 1
var status = en.STATUS.ALIVE
var max_health
var health
var attack
var defense
var actor_name
var is_unique = false

func move():
	if direction == Vector2.LEFT:
		Actor_Sprite.flip_h = true
	elif direction == Vector2.RIGHT:
		Actor_Sprite.flip_h = false
	var new_position = position + direction * data.tile_size
	position = new_position

func take_damage(attack_value):
	var damage = attack_value - defense #* modifier
	health = max(0, health - damage)
	
	events.emit_signal("bar_value_changed", self, health)
	
	if health == 0:
		status = en.STATUS.DEAD
		
	return damage


