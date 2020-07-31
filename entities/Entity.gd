class_name Entity

extends KinematicBody2D

onready var Grid = get_parent()
onready var tile_size = Grid.tile_size
var moving = false
var direction = Vector2()
var speed_inv = 0.1

var level = 1
var max_health = 1
var health = 1
var attack = 0
var defense = 0
var status = en.STATUS.ALIVE

func move():
	if direction == dir.left:
		$AnimatedSprite.flip_h = true
	elif direction == dir.right:
		$AnimatedSprite.flip_h = false
	var new_position = position + direction * tile_size
	$Tween.interpolate_property (self, 'position', position, new_position, speed_inv, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	#$AnimatedSprite.stop() # here should be the moving animation
	moving = true

func take_damage(attack_value):
	var damage = attack_value - defense #* modifier
	health = max(0, health - damage)
	
	if health == 0:
		if self.has_method("get_input"):
			#gameover
			pass
		else:
			status = en.STATUS.DEAD

func _on_Tween_tween_completed(_object, _key):
	moving = false
	
func remove():
	self.queue_free()
	Grid.enemies.erase(self)
