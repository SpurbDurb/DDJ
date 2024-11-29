extends State

var direction: Vector3

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6

func enter() -> void:
	animation_player.play("run")

func update(_deta:float):
	if Input.is_action_just_pressed("ui_accept"):
		exit_state = true
		return
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
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
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	if input_dir.length() > 0:
		return true
	return false
