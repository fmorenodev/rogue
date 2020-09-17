extends ColorRect

func fade_in():
	$AnimationPlayer.play("fade_in")

func _on_AnimationPlayer_animation_finished(_anim_name):
	events.emit_signal("fade_finished")
