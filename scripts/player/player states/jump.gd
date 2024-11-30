extends State

var direction: Vector3

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6

func enter():
	if player.velocity.y > 0:
		animation_player.play("jump")
	else:
		animation_player.play("air")

func update(_delta: float):
	move()

func move():
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.visual.look_at(player.position + direction)
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED

func enter_condition() -> bool:
	if !player.is_on_floor():
		return true
	if player.is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		player.velocity.y = 3
		return true
	return false

func exit_condition() -> bool:
	return player.is_on_floor()
