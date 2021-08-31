extends ColorRect

func fade_in() -> void:
	$AnimationPlayer.play("fade_in")

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	events.emit_signal("fade_finished")
