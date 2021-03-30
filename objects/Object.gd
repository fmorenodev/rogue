class_name E_Object

extends AnimatedSprite

onready var Grid = get_parent()

var can_interact
var interaction 
var args = ["placeholder"]
var object_name

func _ready():
	events.emit_signal("add_entity_info", self, object_name, self.frames.get_frame("default", 0), en.ENTITY_TYPE.OBJECT)
	var _err = events.connect("object_info_added", self, "_on_info_added")

func remove():
	events.emit_signal("entity_removed", self)
	Grid.objects.erase(self)
	self.queue_free()

func _on_info_added(info_node):
	if !events.is_connected("entity_removed", info_node, "_on_Entity_removed"):
		var _err = events.connect("entity_removed", info_node, "_on_Entity_removed")
