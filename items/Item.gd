class_name Item

extends Sprite

var inventory = preload("res://menus/inventory/Inventory.tres")

var item_name: String
var desc: String

func _ready() -> void:
	var _err = events.connect("item_info_added", self, "_on_info_added")
	events.emit_signal("add_entity_info", self, item_name, self.texture, en.ENTITY_TYPE.ITEM)
	
func manual_init() -> void:
	events.emit_signal("add_entity_info", self, item_name, self.texture, en.ENTITY_TYPE.ITEM)

func pick_up(_owner: Actor) -> bool:
	var item = self.duplicate()
	var result = inventory.set_item(item)
	return result if result == false else true
	
func use_turn(user: Actor) -> void:
	user.Grid.end_turn()
	
func remove() -> void:
	events.emit_signal("entity_removed", self)
	
func _on_info_added(info_node: EntityInfo):
	if !events.is_connected("entity_removed", info_node, "_on_Entity_removed"):
		var _err = events.connect("entity_removed", info_node, "_on_Entity_removed")
