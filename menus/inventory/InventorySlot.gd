extends CenterContainer

onready var Item_Texture = $ItemTexture
onready var Selector = $Selector
onready var Amount = $ItemTexture/Amount
onready var Inv_Display = get_parent()
var inventory = preload("res://menus/inventory/Inventory.tres")
var default_texture = preload("res://assets/Menus/inventory/empty_slot.png")

func _ready() -> void:
	var _err = connect("mouse_entered", self, "_on_Slot_hover")
	_err = connect("mouse_exited", self, "_on_Slot_hover_end")

func _on_Slot_hover() -> void:
	Selector.show()
	Inv_Display.selected_slot = get_index()

func _on_Slot_hover_end() -> void:
	Selector.hide()

func display_item(item: Item) -> void:
	if item is Item:
		Item_Texture.texture = item.texture
		hint_tooltip = item.desc
		Amount.text = str(item.amount)
	else:
		Item_Texture.texture = default_texture
		hint_tooltip = ''
		Amount.text = ''

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.texture
		drag_preview.rect_min_size = Item_Texture.rect_min_size
		drag_preview.stretch_mode = TextureRect.STRETCH_SCALE
		set_drag_preview(drag_preview)
		inventory.drag_data = data
		return data

func can_drop_data(_position, data) -> bool:
	return data is Dictionary and data.has("item")

func drop_data(_position, data) -> void:
	var item_index = get_index()
	var item = inventory.items[item_index]
	if item is Item and item.item_name == data.item.item_name:
		inventory.change_amount(item_index, data.item.amount)
	else:
		inventory.swap_items(item_index, data.item_index)
		inventory.set_item(data.item, item_index)
	inventory.drag_data = null
