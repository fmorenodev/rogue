# warning-ignore-all:unused_signal
extends Node

# map management
signal build_level
signal level_loaded
signal item_spawned(item)
signal ally_spawned(ally)

# GUI
signal add_entity_info(node, info_text, texture, entity_type)
signal add_actor_info(node, info_text, texture, bar_text)
signal add_allied_info(node, info_text, texture, bar_text)

signal allied_info_added(info_node)
signal enemy_info_added(info_node)
signal item_info_added(info_node)
signal object_info_added(info_node)

signal actor_removed(node)
signal entity_removed(node)

signal max_bar_value_changed(max_bar_value)
signal bar_value_changed(node, bar_value)
signal attack_changed(attack)
signal defense_changed(defense)

signal sprite_changed(node, new_texture)

# Player
signal change_control(status)

# Menus
signal open_inventory
signal items_changed(indexes)
signal use_item(item, item_index)
signal item_used(item)

signal open_skills
signal skill_added(skill_index)
signal use_skill(skill)

signal close_popups

# Text log
signal new_message(msg, color, args)

# Turn system
signal turn_started(current_actor)
signal end_turn()
signal new_game
signal game_over(current_floor, enemy)

# reloading main scene for new game
signal reload_all

# Animations
signal fade_finished
