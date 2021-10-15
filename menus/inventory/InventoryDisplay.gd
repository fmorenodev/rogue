# warning-ignore-all:narrowing_conversion
extends GridContainer

onready var Slot = preload("res://menus/inventory/InventorySlot.tscn")
onready var Syringe = preload("res://items/Syringe.tscn")
onready var Inventory_Popup = get_parent().get_parent()
onready var Inventory_Container = get_parent().get_parent().get_parent().get_parent()
var inventory = preload("res://menus/inventory/Inventory.tres")

var selected_slot: int = 0
var last_focused: Node

func _ready() -> void:
	var _err = events.connect("items_changed", self, "_on_items_changed")
	_err = events.connect("item_used", self, "_on_item_used")
	inventory.items = []
	for slot in pow(columns, 2): # for testing purposes
		var new_slot = Slot.instance()
		add_child(new_slot)
		var item = Syringe.instance()
		item.add_type(en.SYRINGE_TYPE.values()[randi() % 4])
		inventory.items.append(item)
	update_inventory_display()
	show_selector()
	
func show_selector() -> void:
	last_focused = get_child(selected_slot)
	last_focused.Selector.show()
	
func hide_selector() -> void:
	get_child(selected_slot).Selector.hide()
		
func _input(event: InputEvent) -> void:
	if Inventory_Container.visible and Inventory_Popup.visible:
		if selected_slot != last_focused.get_index():
			last_focused.Selector.hide()
		if event.is_action_pressed("ui_up", true):
			hide_selector()
			selected_slot -= columns
			if selected_slot < 0:
				selected_slot += pow(columns, 2)
			show_selector()
		if event.is_action_pressed("ui_down", true):
			hide_selector()
			selected_slot += columns
			if selected_slot >= pow(columns, 2):
				selected_slot -= pow(columns, 2)
			show_selector()
		if event.is_action_pressed("ui_left", true):
			hide_selector()
			selected_slot -= 1
			if (selected_slot % columns == columns - 1) or selected_slot < 0:
				selected_slot += columns
			if selected_slot > pow(columns, 2):
				selected_slot -= columns
			show_selector()
		if event.is_action_pressed("ui_right", true):
			hide_selector()
			selected_slot += 1
			if selected_slot % columns == 0:
				selected_slot -= columns
			show_selector()
		if event.is_action_pressed("ui_accept"):
			if inventory.items[selected_slot] != null:
				events.emit_signal("use_item", inventory.items[selected_slot], selected_slot)
			get_tree().set_input_as_handled()
		if event is InputEventMouseButton and event.pressed:
			match event.button_index:
				BUTTON_RIGHT:
					if inventory.items[selected_slot] != null:
						events.emit_signal("use_item", inventory.items[selected_slot], selected_slot)

func update_slot_display(item_index: int) -> void:
	var slot = get_child(item_index)
	var item = inventory.items[item_index]
	slot.display_item(item)

func update_inventory_display() -> void:
	for item_index in inventory.items.size():
		update_slot_display(item_index)
	
func _on_items_changed(item_indexes: PoolIntArray) -> void:
	for i in item_indexes:
		update_slot_display(i)
		
func _on_item_used() -> void:
	yield(get_tree().create_timer(0.01), "timeout")
	var item = inventory.items[selected_slot]
	if !is_instance_valid(item):
		inventory.items[selected_slot] = null
	update_slot_display(selected_slot)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item, inventory.drag_data.item_index)
