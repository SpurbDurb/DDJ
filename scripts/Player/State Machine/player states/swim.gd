extends Player_State

var direction: Vector3
var camera_pivot
var player_speed: float

func _ready() -> void:
	player_speed = SWIM_SPEED
	call_deferred("_deferred_ready")
	
func _deferred_ready() -> void:
	camera_pivot = get_tree().get_current_scene().get_node("camera_pivot")

func enter() -> void:
	animation_player.play("swim")
	%CollisionSwim.disabled = false
	player.collision_layer = (1 << 1) | (1 << 2)  # Enable layers 2 and 3

func exit() -> void:
	%CollisionSwim.disabled = true
	player.collision_layer = (1 << 0) | (1 << 1)  # Enable layers 1 and 2

func update(_deta:float):
	var input_dir := get_input()
	if input_dir.length() > 0:
		direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		player.look_at(player.position + direction)
		player.velocity.x = direction.x * player_speed
		player.velocity.z = direction.z * player_speed
	else:
		player.velocity.x = 0
		player.velocity.z = 0

func exit_condition() -> bool:
	return true

func enter_condition() -> bool:
	return player.is_in_water

func get_input() -> Vector2:
	if character == "White":
		return Input.get_vector("left", "right", "forward", "backward")
	# Black
	return Input.get_vector("left2", "right2", "forward2", "backward2")
