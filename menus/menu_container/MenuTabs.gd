extends TabContainer

func _ready() -> void:
	for key in data.tabs:
		set_tab_title(data.tabs[key], key)
