extends TabContainer

func _ready():
	for key in data.tabs:
		set_tab_title(data.tabs[key], key)
