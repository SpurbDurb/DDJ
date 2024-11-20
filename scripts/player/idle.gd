extends State

func Enter():
	animation_player.play("idle")

func Update(delta: float):
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		state_transition.emit(self, "run")
	player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
	player.move_and_slide()
