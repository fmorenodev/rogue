extends WindowDialog

onready var Menu_Tabs = $MenuTabs
var inventory = preload("res://menus/inventory/Inventory.tres")

func _ready() -> void:
	var _err = events.connect("open_inventory", self, "_on_inventory_open")
	_err = events.connect("open_skills", self, "_on_skills_open")
	_err = connect("popup_hide", self, "_on_popup_hide")
	window_title = tr("MENU")
	
func _on_inventory_open() -> void:
	open_tab(data.tabs.get(tr("INVENTORY")))
	
func _on_skills_open() -> void:
	open_tab(data.tabs.get(tr("SKILLS")))
		
func open_tab(tab: int) -> void:
	if !visible:
		popup()
		Menu_Tabs.current_tab = tab
		events.emit_signal("change_control", false)
	else:
		hide()
		
func _on_popup_hide() -> void:
	events.emit_signal("change_control", true)
