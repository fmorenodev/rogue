class_name E_Object

extends Sprite

onready var Grid = get_parent()

var can_interact: bool
var interaction: String
var args = ["placeholder"]
var object_name: String

func _ready() -> void:
	var _err = events.connect("object_info_added", self, "_on_info_added")

func manual_init() -> void:
	events.emit_signal("add_entity_info", self, object_name, self.frames.get_frame("default", 0), en.ENTITY_TYPE.OBJECT)

func remove() -> void:
	Grid.objects.erase(self)
	data.entities.erase(self)
	events.emit_signal("entity_removed", self)
	self.queue_free()

func _on_info_added(info_node: EntityInfo) -> void:
	if !events.is_connected("entity_removed", info_node, "_on_Entity_removed"):
		var _err = events.connect("entity_removed", info_node, "_on_Entity_removed")
