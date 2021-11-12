extends Label

func _ready():
	var _err = events.connect("switch_target", self, "_on_switch_target")

func _on_switch_target(_targets: PoolVector2Array):
	visible = !visible
	if visible:
		text = tr("SELECT_TARGET")
