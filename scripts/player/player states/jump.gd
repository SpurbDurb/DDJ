extends State

var direction: Vector3

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6

func Enter():
	if player.velocity.y > 0:
		animation_player.play("jump")
	else:
		animation_player.play("air")

func Exit():
	animation_player.play("land")

func Update(_delta: float):
	move()
	Handle_state_transition(_delta)

func move():
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.visual.look_at(player.position + direction)
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED

func Handle_state_transition(_delta: float):
	if not player.is_on_floor():
		return
	if direction:
		state_transition.emit(self, "run")
		return
	else:
		state_transition.emit(self, "idle")
