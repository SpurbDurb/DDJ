extends Player_State

var direction: Vector3

func enter() -> void:
	animation_player.play("run")

func update(_deta:float):
	if character == "White" and Input.is_action_just_pressed("jump"):
		exit_state = true
		return
	elif character == "Black" and Input.is_action_just_pressed("jump2"):
		exit_state = true
		return
	
	var input_dir := get_input()
	direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		exit_state = false
		player.visual.look_at(player.position + direction)
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	else:
		exit_state = true

func exit_condition() -> bool:
	return exit_state or !player.is_on_floor()

func enter_condition() -> bool:
	var input_dir := get_input()
	if input_dir.length() > 0:
		return true
	return false

func get_input() -> Vector2:
	if character == "White":
		return Input.get_vector("left", "right", "forward", "backward")
	# Black
	return Input.get_vector("left2", "right2", "forward2", "backward2")
