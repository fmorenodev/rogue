extends VBoxContainer

var level_text: String = tr("LEVEL_STAT")
var attack_text: String = tr("ATTACK_STAT")
var defense_text: String = tr("DEFENSE_STAT")

onready var Level_label = $Level
onready var Attack_label = $Attack
onready var Defense_label = $Defense
onready var Health_bar = $Control/HealthBar

func _ready():
	var _err = events.connect("max_health_changed", self, "_on_Player_max_health_changed")
	_err = events.connect("health_changed", self, "_on_Player_health_changed")
	_err = events.connect("level_changed", self, "_on_Player_level_changed")
	_err = events.connect("attack_changed", self, "_on_Player_attack_changed")
	_err = events.connect("defense_changed", self, "_on_Player_defense_changed")

func _on_Player_max_health_changed(max_health):
	Health_bar.max_value = max_health

func _on_Player_health_changed(health):
	Health_bar.value = health

func _on_Player_level_changed(level):
	Level_label.text = level_text.format([level])
	
func _on_Player_attack_changed(attack):
	Attack_label.text = attack_text.format([attack])
	
func _on_Player_defense_changed(defense):
	Defense_label.text = defense_text.format([defense])
