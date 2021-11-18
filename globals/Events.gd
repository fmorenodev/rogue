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

signal ally_removed(node)
signal actor_removed(node)
signal entity_removed(node)

signal max_bar_value_changed(node, max_bar_value)
signal bar_value_changed(node, bar_value)
signal attack_changed(node, attack)
signal defense_changed(node, defense)
signal sprite_changed(node, new_texture)

# Player
signal change_control(status)

signal switch_look
signal look_at_entity(entity)
signal switch_target
signal choose_target
signal target_chosen(pos)

# Menus
signal open_inventory
signal items_changed(indexes)
signal use_item(item, item_index)
signal item_used(item)

signal open_skills
signal skill_added(skill_index)
signal use_skill(skill)
signal calc_targets(pos, tile_range, overlay)
signal targets_calculated(targets)
signal area_effect(targets, effect)

signal close_popups

# Text log
signal new_message(msg, color, args)
signal new_message_no_newline(msg, color, args)

# Turn system
signal turn_started(current_actor)
signal end_turn
signal switch_input(boolean)
signal new_game
signal game_over(current_floor, enemy)

# reloading main scene for new game
signal reload_all

# Animations
signal fade_finished

# Sound
signal play_sound(sound)
signal play_music(music)
