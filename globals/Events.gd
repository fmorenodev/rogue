# warning-ignore-all:unused_signal
extends Node

# map management
signal build_level
signal level_loaded

# GUI
signal max_health_changed(max_health)
signal health_changed(health)
signal level_changed(level)
signal attack_changed(attack)
signal defense_changed(defense)

# Text log
signal new_message(msg, color, args)

# Turn system
signal turn_started(current_actor)
signal new_game_cleanup
signal new_game
signal game_over(current_floor, enemy)

# Animations
signal fade_finished
