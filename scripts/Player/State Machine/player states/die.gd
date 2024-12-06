extends Player_State

func enter():
	animation_player.play("dye")
	player.queue_free()

func exit_condition() -> bool:
	return false

func enter_condition() -> bool:
	return false
