class_name Actor

extends KinematicBody2D

onready var Grid: TileMap = get_parent()
onready var Actor_Sprite = $Sprite
var direction = Vector2()

var level = 1
var status = en.STATUS.ALIVE
var max_health: int
var health: int
var attack: int
var defense: int
var actor_name: String
var is_unique = false

func move() -> void:
	if direction == Vector2.LEFT:
		Actor_Sprite.flip_h = true
	elif direction == Vector2.RIGHT:
		Actor_Sprite.flip_h = false
	var new_position: Vector2 = position + Grid.map_to_world(direction)
	position = new_position

func take_damage(attack_value: int) -> int:
	var damage: int = attack_value - defense #* modifier
	health = max(0, health - damage)
	
	events.emit_signal("bar_value_changed", self, health)
	
	if health == 0:
		status = en.STATUS.DEAD
		
	return damage
