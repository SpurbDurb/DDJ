extends CharacterBody3D

@onready var state_machine = $"state machine"

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6
@export var SENS = 0.04

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	
	# Assign the shared data to the states and initialize state machine
	for state in state_machine.get_children():
		state.animation_player = animation_player
		state.player = player
		state.visual = visual
		state.SPEED = SPEED
	state_machine.init()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENS))

func _physics_process(delta: float) -> void:
	#gravity
	velocity += get_gravity() * delta
	#move
	move_and_slide()
