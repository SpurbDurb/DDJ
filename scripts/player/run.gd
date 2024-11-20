extends State

func Enter():
	animation_player.play("run")
	pass

func Update(delta: float):
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.visual.look_at(player.position - direction)
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	else: 
		state_transition.emit(self, "idle")
	player.move_and_slide()
