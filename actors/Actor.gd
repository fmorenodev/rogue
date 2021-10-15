# warning-ignore-all:narrowing_conversion
class_name Actor

extends KinematicBody2D

onready var Grid: TileMap = get_parent()
onready var Actor_Sprite = $Sprite
var direction = Vector2()

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
	var damage = attack_value - defense if attack_value > defense else 1
	modify_health(-damage)

	return damage

func modify_health(hp: int) -> void:
	if hp > 0:
		health = min(health + hp, max_health)
	elif hp < 0:
		health = max(0, health + hp)
		if health == 0:
			status = en.STATUS.DEAD
	events.emit_signal("bar_value_changed", self, health)

func modify_defense(def: int) -> void:
	defense += def
	events.emit_signal("defense_changed", defense)
