extends HBoxContainer

var inventory = preload("res://menus/inventory/Inventory.tres")

		
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	inventory.set_item(data.item, data.item_index)
