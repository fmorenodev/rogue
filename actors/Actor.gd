# warning-ignore-all:narrowing_conversion
class_name Actor

extends KinematicBody2D

onready var Grid: TileMap = get_parent()
onready var Actor_Sprite = $Sprite
onready var Audio_Player: AudioStreamPlayer = get_node("../AudioStreamPlayer")
onready var Anim_Player: AnimationPlayer = get_node("../AnimationPlayer")
var direction = Vector2()

var type: int
var status = en.STATUS.ALIVE
var max_health: int
var health: int
var attack: int
var defense: int
var entity_name: String
var desc: String
var attack_sound: int
var is_unique = false

func move() -> void:
	if direction.x == -1:
		Actor_Sprite.flip_h = true
	elif direction.x == 1:
		Actor_Sprite.flip_h = false
	var new_position: Vector2 = position + Grid.map_to_world(direction)
	position = new_position
	
func forward_animation():
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	var node_path = get_path()
	animation.length = 0.25
	animation.track_set_path(track_index, '{0}:position'.format([node_path]))
	animation.track_insert_key(track_index, 0.1, position + (direction * 16 / 2))
	animation.track_insert_key(track_index, 0.2, position)
	var _err = Anim_Player.add_animation("forward", animation)
	Anim_Player.play("forward")

func basic_attack(target: Actor):
	forward_animation()
	events.emit_signal("play_sound", attack_sound)
	var msg_color = color.cyan if target.is_in_group("enemies") else color.light_red
	events.emit_signal("new_message", tr("COMBAT_ATTACK"),
		msg_color, [self.entity_name, target.entity_name])
	var _damage = target.take_damage(attack)

func remove() -> void:
	Grid.actors.erase(self)
	data.entities.erase(self)

func take_damage(attack_value: int) -> int:
	var damage = attack_value - defense if attack_value > defense else 1
	events.emit_signal("new_message_no_newline", tr("TAKE_DAMAGE"),
		color.white, [self.entity_name, damage])
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
	if status == en.STATUS.DEAD:
		if name != 'Player':
			events.emit_signal("new_message", tr("ACTOR_DEAD"),
				color.red, [entity_name])
			remove()

func modify_defense(def: int) -> void:
	defense += def
	events.emit_signal("defense_changed", self, defense)
