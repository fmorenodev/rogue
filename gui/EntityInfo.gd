class_name EntityInfo

extends VBoxContainer

onready var Info_Label = $InfoContainer/Info
onready var Entity_Sprite = $InfoContainer/EntitySprite

var node_connected

func entity_info_init(node, text, sprite, entity_type):
	Info_Label.text = text.capitalize()
	Entity_Sprite.texture = sprite.texture
	node_connected = node
	match entity_type:
		en.ENTITY_TYPE.ITEM:
			events.emit_signal("item_info_added", self)
		# if actor do nothing?
	
func _on_Entity_removed():
	self.queue_free()
