extends Player_State

func _ready() -> void:
	exit_state = true

func enter():
	animation_player.play("idle")

func update(_delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, SPEED)

func enter_condition() -> bool:
	if !player.is_on_floor() or player.is_in_water:
		return false
	
	var input_dir := get_input()
	if character == "White" and !Input.is_action_just_pressed("jump"):
		return input_dir.length() == 0
	elif character == "Black" and !Input.is_action_just_pressed("jump2"):
		return input_dir.length() == 0
	elif character == "White" and Input.is_action_pressed("push"): return false
	return false

func get_input() -> Vector2:
	if character == "White":
		return Input.get_vector("left", "right", "forward", "backward")
	# Black
	return Input.get_vector("left2", "right2", "forward2", "backward2")
