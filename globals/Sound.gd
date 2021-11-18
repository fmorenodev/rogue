extends AudioStreamPlayer

onready var gunfire = preload("res://assets/sounds/gunfire.wav")
onready var gunshot = preload("res://assets/sounds/gunshot.wav")
onready var punch = preload("res://assets/sounds/punch.wav")
onready var scratch = preload("res://assets/sounds/scratch.wav")
onready var explosion = preload("res://assets/sounds/explosion.wav")
onready var spawn = preload("res://assets/sounds/spawn.wav")
onready var spawn_mech = preload("res://assets/sounds/spawn_mech.wav")
onready var menu_move = preload("res://assets/sounds/menu_move.wav")
onready var menu_press = preload("res://assets/sounds/menu_press.wav")

var first_menu_move: bool = true

func _ready() -> void:
	var _err = events.connect("play_sound", self, "_on_play_sound")
	
func _on_play_sound(sound: int) -> void:
	match sound:
		en.SOUNDS.GUNFIRE:
			stream = gunfire
		en.SOUNDS.GUNSHOT:
			stream = gunshot
		en.SOUNDS.PUNCH:
			stream = punch
		en.SOUNDS.SCRATCH:
			stream = scratch
		en.SOUNDS.EXPLOSION:
			stream = explosion
		en.SOUNDS.SPAWN:
			stream = spawn
		en.SOUNDS.SPAWN_MECH:
			stream = spawn_mech
		en.SOUNDS.MENU_MOVE:
			if first_menu_move:
				first_menu_move = false
				stream = null
			else:
				stream = menu_move
		en.SOUNDS.MENU_PRESS:
			stream = menu_press
			first_menu_move = true
	play()
