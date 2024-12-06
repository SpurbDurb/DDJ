extends Player_State

func enter():
	player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
	
	animation_player.play("dye")
	animation_player.connect("animation_finished", Callable(self,"_on_animation_finished"))

func _on_animation_finished(anim_name):
	if anim_name == "dye":
		player.queue_free() 
		animation_player.disconnect("animation_finished", Callable(self,"_on_animation_finished"))

func exit_condition() -> bool:
	return false

func enter_condition() -> bool:
	return false
