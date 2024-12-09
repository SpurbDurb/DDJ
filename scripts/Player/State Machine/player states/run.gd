extends Player_State

@export var SPRINT_SPEED: float = 3
var direction: Vector3
var camera_pivot
var player_speed: float

func _ready() -> void:
	player_speed = SPEED
	call_deferred("_deferred_ready")
	
func _deferred_ready() -> void:
	camera_pivot = get_tree().get_current_scene().get_node("camera_pivot")

func enter() -> void:
	animation_player.play("run")

func update(_deta:float):
	if character == "White":
		if Input.is_action_pressed("sprint"):
			player_speed = SPRINT_SPEED
		else:
			player_speed = SPEED
	
	var input_dir := get_input()
	direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		player.look_at(player.position + direction)
		player.velocity.x = direction.x * player_speed
		player.velocity.z = direction.z * player_speed

func exit_condition() -> bool:
	return true

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
