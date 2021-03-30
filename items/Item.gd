class_name Item

extends Sprite

onready var Grid = get_parent()
var item_name

func _ready():
	var _err = events.connect("item_info_added", self, "_on_info_added")
	events.emit_signal("add_entity_info", self, item_name, self, en.ENTITY_TYPE.ITEM)

func pick_up(_owner):
	#add to inventory
	events.emit_signal("entity_removed")
	Grid.items.erase(self)
	self.queue_free()
	
func _on_info_added(info_node):
	if !events.is_connected("entity_removed", info_node, "_on_Entity_removed"):
		var _err = events.connect("entity_removed", info_node, "_on_Entity_removed")
