extends Node
# warning-ignore-all:unused_signal

# map management
signal build_level

# GUI
signal max_health_changed(max_health)
signal health_changed(health)
signal level_changed(level)
signal attack_changed(attack)
signal defense_changed(defense)

# Text log
signal new_message(msg, color, args)
signal new_message_newline(msg, color, args)

# Turn system
signal turn_started(current_actor)
signal new_game
signal game_over(current_floor, enemy)
