extends Player_State

var direction: Vector3
var camera_pivot


func _ready() -> void:
	call_deferred("_deferred_ready")
func _deferred_ready() -> void:
	camera_pivot = get_tree().get_current_scene().get_node("camera_pivot")

func enter():
	if player.velocity.y > 0:
		animation_player.play("jump")
	else:
		animation_player.play("air")

func update(_delta: float):
	move()

func move():
	var input_dir := get_input()
	direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.look_at(player.position + direction)
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED

func enter_condition() -> bool:
	if !player.is_on_floor():
		return true
	
	if character == "White" and player.is_on_floor() and Input.is_action_just_pressed("jump"):
		player.velocity.y = 3
		return true
	if character == "Black" and player.is_on_floor() and Input.is_action_just_pressed("jump2"):
		player.velocity.y = 3
		return true
	return false

func exit_condition() -> bool:
	return player.is_on_floor()

func get_input() -> Vector2:
	if character == "White":
		return Input.get_vector("left", "right", "forward", "backward")
	# Black
	return Input.get_vector("left2", "right2", "forward2", "backward2")
