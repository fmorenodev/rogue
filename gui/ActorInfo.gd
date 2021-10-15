class_name ActorInfo

extends VBoxContainer

var Bar
var Bar_Label
var node_connected: Actor

func actor_info_init(node: Actor, info_text: String, texture, bar_text: String = "HEALTH_BAR", is_actor: bool = true) -> void:
	$EntityInfo.entity_info_init(node, info_text, texture, en.ENTITY_TYPE.ACTOR)
	Bar = $LabeledBar/Bar
	Bar_Label = $LabeledBar/BarLabel
	Bar_Label.text = tr(bar_text)
	node_connected = node
	
	var _err = events.connect("max_bar_value_changed", self, "_on_Actor_max_bar_value_changed")
	_err = events.connect("bar_value_changed", self, "_on_Actor_bar_value_changed")
	if is_actor and node.is_in_group("enemies"):
		events.emit_signal("enemy_info_added", self) 

func _on_Actor_max_bar_value_changed(node: Actor, max_bar_value: int) -> void:
	if node == node_connected:
		Bar.max_value = max_bar_value

func _on_Actor_bar_value_changed(node: Actor, bar_value: int) -> void:
	if node == node_connected:
		Bar.value = bar_value
	
func _on_Actor_removed(node: Actor) -> void:
	if node == node_connected:
		self.queue_free()
