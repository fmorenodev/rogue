extends VBoxContainer

var attack_text: String = tr("ATTACK_STAT")
var defense_text: String = tr("DEFENSE_STAT")
var level_text: String = tr("LEVEL_STAT")

onready var Attack_Label = $Attack
onready var Defense_Label = $Defense

func _ready() -> void:
	var _err = events.connect("level_changed", self, "_on_Ally_level_changed")
	_err = events.connect("attack_changed", self, "_on_Ally_attack_changed")
	_err = events.connect("defense_changed", self, "_on_Ally_defense_changed")

# change type Player when (if) including allies
func allied_info_init(node: Player, info_text: String, texture, bar_text: String = "HEALTH_BAR") -> void:
	$ActorInfo.actor_info_init(node, info_text, texture, bar_text, false)
	if info_text == tr("PLAYER_NAME"):
		events.emit_signal("player_info_added")

func _on_Ally_level_changed(name: String, level: int) -> void:
	var Info_Label = $ActorInfo/EntityInfo/InfoContainer/Info
	Info_Label.text = level_text.format([name, level])

func _on_Ally_attack_changed(attack: int) -> void:
	Attack_Label.text = attack_text.format([attack])

func _on_Ally_defense_changed(defense: int) -> void:
	Defense_Label.text = defense_text.format([defense])
