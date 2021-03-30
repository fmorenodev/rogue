class_name EntityInfo

extends VBoxContainer

onready var Info_Label = $InfoContainer/Info
onready var Entity_Sprite = $InfoContainer/EntitySprite

var node_connected

func entity_info_init(node, text, texture, entity_type):
	Info_Label.text = text.capitalize()
	if Info_Label.get_line_count() > 1:
		self.rect_min_size.y = 25 + (Info_Label.get_line_count() - 1) * 16
	Entity_Sprite.texture = texture
	node_connected = node
	match entity_type:
		en.ENTITY_TYPE.ITEM:
			events.emit_signal("item_info_added", self)
		# if actor do nothing?
		en.ENTITY_TYPE.OBJECT:
			events.emit_signal("object_info_added", self)
			var _err = events.connect("sprite_changed", self, "_on_Sprite_change")
		
func _on_Sprite_change(node, new_texture):
	if node == node_connected:
		Entity_Sprite.texture = new_texture
	
func _on_Entity_removed(node):
	if node == node_connected:
		self.queue_free()
