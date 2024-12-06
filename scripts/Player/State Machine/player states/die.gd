extends Player_State

func enter():
	animation_player.play("dye")
	player.queue_free()
