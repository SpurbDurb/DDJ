extends State

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6

func _ready() -> void:
	exit_state = true

func enter():
	animation_player.play("idle")

func update(_delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, SPEED)

func enter_condition() -> bool:
	if !player.is_on_floor():
		return false
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	return input_dir.length() == 0 and !Input.is_action_just_pressed("ui_accept")
