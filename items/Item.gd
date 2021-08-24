class_name Item

extends Sprite

onready var Grid = get_parent()
var item_name: String

func _ready() -> void:
	var _err = events.connect("item_info_added", self, "_on_info_added")
	events.emit_signal("add_entity_info", self, item_name, self.texture, en.ENTITY_TYPE.ITEM)
	
func manual_init() -> void:
	events.emit_signal("add_entity_info", self, item_name, self.texture, en.ENTITY_TYPE.ITEM)

func pick_up(_owner: Actor) -> void:
	#add to inventory
	events.emit_signal("entity_removed", self)
	Grid.items.erase(self)
	self.queue_free()
	
func _on_info_added(info_node: EntityInfo):
	if !events.is_connected("entity_removed", info_node, "_on_Entity_removed"):
		var _err = events.connect("entity_removed", info_node, "_on_Entity_removed")
