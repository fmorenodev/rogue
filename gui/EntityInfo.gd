class_name EntityInfo

extends VBoxContainer

onready var Info_Label = $InfoContainer/Info
onready var Entity_Sprite = $InfoContainer/EntitySprite

var node_connected

# no entity class made, entity_type is enum
func entity_info_init(node, text: String, texture, entity_type: int) -> void:
	Info_Label.text = text.capitalize()
	if Info_Label.get_line_count() > 1:
		self.rect_min_size.y = 25 + (Info_Label.get_line_count() - 1) * 16
	Entity_Sprite.texture = texture
	node_connected = node
	match entity_type:
		en.ENTITY_TYPE.ITEM:
			events.emit_signal("item_info_added", self)
		en.ENTITY_TYPE.OBJECT, _:
			events.emit_signal("object_info_added", self)
			var _err = events.connect("sprite_changed", self, "_on_Sprite_change")

		
func _on_Sprite_change(node, new_texture) -> void:
	if node == node_connected:
		Entity_Sprite.texture = new_texture
	
func _on_Entity_removed(node) -> void:
	if node == node_connected:
		self.queue_free()
