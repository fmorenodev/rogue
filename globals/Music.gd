extends AudioStreamPlayer

onready var menu = preload("res://assets/music/menu_music.wav")
onready var main = preload("res://assets/music/main_music.wav")
onready var game_over_intro = preload("res://assets/music/game_over_intro.wav")
onready var game_over_loop = preload("res://assets/music/game_over_loop.wav")

func _ready() -> void:
	var _err = events.connect("play_music", self, "_on_play_music")

func _on_play_music(music: int) -> void:
	match music:
		en.MUSIC.MENU:
			stream = menu
		en.MUSIC.MAIN:
			stream = main
		en.MUSIC.GAME_OVER_INTRO:
			stream = game_over_intro
			if !is_connected("finished", self, "_on_game_over_intro_finished"):
				var _err = connect("finished", self, "_on_game_over_intro_finished")
		en.MUSIC.GAME_OVER_LOOP:
			stream = game_over_loop
	play()

func _on_game_over_intro_finished() -> void:
	stream = game_over_loop
	play()
	disconnect("finished", self, "_on_game_over_intro_finished")
