class_name Item

extends Sprite

var inventory = preload("res://menus/inventory/Inventory.tres")

var item_name: String
var desc: String
var amount = 1
var stackable = true

func _ready() -> void:
	var _err = events.connect("item_info_added", self, "_on_info_added")
	events.emit_signal("add_entity_info", self, item_name, self.texture, en.ENTITY_TYPE.ITEM)

func manual_init() -> void:
	events.emit_signal("add_entity_info", self, item_name, self.texture, en.ENTITY_TYPE.ITEM)

func pick_up(_owner: Actor) -> bool:
	var item = self.clone()
	var result = inventory.set_item(item)
	if result is bool or result == null:
		return false
	else:
		return true

func use_turn(user: Actor) -> void:
	user.Grid.end_turn()

func remove() -> void:
	data.entities.erase(self)
	events.emit_signal("entity_removed", self)

func _on_info_added(info_node: EntityInfo) -> void:
	if !events.is_connected("entity_removed", info_node, "_on_Entity_removed"):
		var _err = events.connect("entity_removed", info_node, "_on_Entity_removed")

func clone() -> Item:
	var cloned_item: Item = self.duplicate()
	cloned_item.item_name = self.item_name
	cloned_item.desc = self.desc
	cloned_item.amount = self.amount
	cloned_item.stackable = self.stackable
	return cloned_item
