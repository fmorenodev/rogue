extends TextureRect

var inventory = preload("res://menus/inventory/Inventory.tres")
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	inventory.remove_item(data.item_index)
