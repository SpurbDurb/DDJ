extends State

var direction: Vector3

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6

func Enter():
	animation_player.play("run")

func Update(_delta: float):
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.visual.look_at(player.position + direction)
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	Handle_state_transition(_delta)

func Handle_state_transition(_delta: float):
	if (Input.is_action_just_pressed("ui_accept") and player.is_on_floor()):
		player.velocity.y = SPEED
		state_transition.emit(self, "jump")
		return
	if not player.is_on_floor():
		state_transition.emit(self, "jump")
		return
	
	if not direction:
		state_transition.emit(self, "idle")
		return
