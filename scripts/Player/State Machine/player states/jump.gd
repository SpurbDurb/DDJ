extends Player_State

var direction: Vector3
var camera_pivot
var is_walking: bool = false

func _ready() -> void:
	call_deferred("_deferred_ready")

func _deferred_ready() -> void:
	camera_pivot = get_tree().get_current_scene().get_node("camera_pivot")

func enter():
	# Initialize jump state and animation based on velocity
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
	if not player.is_on_floor() and not player.is_in_water: return true
	# Handling jump input and start of the jump
	if character == "White" and player.is_on_floor() and Input.is_action_just_pressed("jump"):
		animation_player.speed_scale = 1
		player.velocity.y = 3
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Jump)
		return true
	if character == "Black":
		if player.is_on_floor() and Input.is_action_just_pressed("jump2"):
			player.velocity.y = 3
			AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Jump)
			return true
		elif player.is_in_water and Input.is_action_just_pressed("jump2"):
			player.velocity.y = 3.5
			return true
	return false

func exit_condition() -> bool:
	if player.velocity.y == 0 or (player.is_in_water and player.velocity.y <= 0):
		if not player.is_in_water:
			AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Land)
		return true
	return false

func get_input() -> Vector2:
	if character == "White":
		return Input.get_vector("left", "right", "forward", "backward")
	# Black
	return Input.get_vector("left2", "right2", "forward2", "backward2")
