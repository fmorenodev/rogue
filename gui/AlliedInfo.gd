class_name AlliedInfo

extends VBoxContainer

var attack_text: String = tr("ATTACK_STAT")
var defense_text: String = tr("DEFENSE_STAT")

onready var Attack_Label = $Attack
onready var Defense_Label = $Defense
var node_connected: Actor

func allied_info_init(node: Actor, info_text: String, texture, bar_text: String = "HEALTH_BAR") -> void:
	$ActorInfo.actor_info_init(node, info_text, texture, bar_text, false)
	node_connected = node
	
	var _err = events.connect("attack_changed", self, "_on_Ally_attack_changed")
	_err = events.connect("defense_changed", self, "_on_Ally_defense_changed")
	events.emit_signal("allied_info_added", self)

func _on_Ally_attack_changed(node: Actor, attack: int) -> void:
	if node == node_connected:
		Attack_Label.text = attack_text.format([attack])

func _on_Ally_defense_changed(node: Actor, defense: int) -> void:
	if node == node_connected:
		Defense_Label.text = defense_text.format([defense])

func _on_Ally_removed(node: Actor) -> void:
	if node == node_connected:
		self.queue_free()
