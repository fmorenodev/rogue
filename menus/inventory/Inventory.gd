class_name Inventory

extends Resource

var items = []
var drag_data = null

# should be item but there are circular dependencies when doing it
func set_item(item: Sprite, item_index: int = -1):
	var index = item_index
	if item_index == -1:
		for i in items.size():
			if items[i] != null and item.item_name == items[i].item_name:
				change_amount(i, item.amount)
				index = i
				return item
		if index == -1:
			index = items.find(null)
			if index == -1:
				return false
	var previous_item = items[index]
	items[index] = item
	events.emit_signal("items_changed", [index])
	return previous_item
	
func swap_items(item_index: int, target_item_index: int) -> void:
	var item = items[item_index]
	var target_item = items[target_item_index]
	items[target_item_index] = item
	items[item_index] = target_item
	events.emit_signal("items_changed", [item_index, target_item_index])
	
func remove_item(item_index: int) -> Sprite:
	var item = items[item_index]
	items[item_index] = null
	events.emit_signal("items_changed", [item_index])
	return item
	
func change_amount(item_index: int, amount: int) -> void:
	var item = items[item_index]
	item.amount += amount
	if item.amount <= 0:
		var _item = remove_item(item_index)
	else:
		events.emit_signal("items_changed", [item_index])
