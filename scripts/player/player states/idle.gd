extends State

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6

func Enter():
	animation_player.play("idle")

func Update(_delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
	Handle_state_transition(_delta)

func Handle_state_transition(_delta: float):
	if (Input.is_action_just_pressed("ui_accept") and player.is_on_floor()):
		player.velocity.y = SPEED
		state_transition.emit(self, "jump")
		return
	if not player.is_on_floor():
		state_transition.emit(self, "jump")
		return
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		state_transition.emit(self, "run")
		return
