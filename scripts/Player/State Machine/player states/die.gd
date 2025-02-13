extends Player_State

func enter():
	player.velocity = Vector3.ZERO
	
	animation_player.play("dye")
	animation_player.connect("animation_finished", Callable(self,"_on_animation_finished"))

func exit():
	animation_player.disconnect("animation_finished", Callable(self,"_on_animation_finished"))

func _on_animation_finished(anim_name):
	if anim_name == "dye":
		player.spawn_player()

func exit_condition() -> bool:
	return false

func enter_condition() -> bool:
	return false
