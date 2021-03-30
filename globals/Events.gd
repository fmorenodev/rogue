# warning-ignore-all:unused_signal
extends Node

# map management
signal build_level
signal level_loaded

# GUI
signal add_entity_info(node, info_text, sprite, entity_type)
signal add_actor_info(node, info_text, sprite, bar_text)
signal add_allied_info(node, info_text, sprite, bar_text)

signal player_info_added
signal enemy_info_added(enemy_node, info_node)
signal item_info_added(info_node)

signal actor_removed(node)
signal entity_removed

signal max_bar_value_changed(max_bar_value)
signal bar_value_changed(node, bar_value)
signal level_changed(actor_name, level)
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
