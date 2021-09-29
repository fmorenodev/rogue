extends MarginContainer

var inventory = preload("res://menus/inventory/Inventory.tres")
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var item = data.item.clone()
	inventory.remove_item(data.item_index)
	inventory.drag_data = null
	item.position = get_global_mouse_position()
	events.emit_signal("item_spawned", item)
