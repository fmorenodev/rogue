extends VBoxContainer

onready var Entity_Info = preload("res://gui/EntityInfo.tscn")
onready var Actor_Info = preload("res://gui/ActorInfo.tscn")
onready var Allied_Info = preload("res://gui/AlliedInfo.tscn")

func _ready() -> void:
	var _err = events.connect("add_entity_info", self, "_on_add_entity_info")
	_err = events.connect("add_actor_info", self, "_on_add_actor_info")
	_err = events.connect("add_allied_info", self, "_on_add_allied_info")
	
# entity has no class
func _on_add_entity_info(node, info_text: String, texture, entity_type: int) -> void:
	var e_info = Entity_Info.instance()
	add_child(e_info)
	e_info.entity_info_init(node, info_text, texture, entity_type)
	
func _on_add_actor_info(node: Actor, info_text: String, texture, bar_text: String) -> void:
	var a_info = Actor_Info.instance()
	add_child(a_info)
	a_info.actor_info_init(node, info_text, texture, bar_text)

func _on_add_allied_info(node: Ally, info_text: String, texture, bar_text: String) -> void:
	var a_info = Allied_Info.instance()
	add_child(a_info)
	a_info.allied_info_init(node, info_text, texture, bar_text)
