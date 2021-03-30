class_name ActorInfo

extends VBoxContainer

var Bar
var Bar_Label
var node_connected

func actor_info_init(node, info_text, sprite, bar_text = "HEALTH_BAR", is_actor = true):
	$EntityInfo.entity_info_init(node, info_text, sprite, en.ENTITY_TYPE.ACTOR)
	Bar = $LabeledBar/Bar
	Bar_Label = $LabeledBar/BarLabel
	Bar_Label.text = tr(bar_text)
	node_connected = node
	
	var _err = events.connect("max_bar_value_changed", self, "_on_Actor_max_bar_value_changed")
	_err = events.connect("bar_value_changed", self, "_on_Actor_bar_value_changed")
	if is_actor:
		events.emit_signal("enemy_info_added", node, self)

func _on_Actor_max_bar_value_changed(node, max_bar_value):
	if node == node_connected:
		Bar.max_value = max_bar_value

func _on_Actor_bar_value_changed(node, bar_value):
	if node == node_connected:
		Bar.value = bar_value
	
func _on_Actor_removed(node):
	if node == node_connected:
		self.queue_free()
