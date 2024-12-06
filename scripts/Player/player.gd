extends CharacterBody3D

@onready var sm = $"state machine"

@export_enum("White", "Black")
var character: String = "White"
@export var spawn: bool = true

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2
@export var SENS = 0.04

func _ready() -> void:
	# Assign the shared data to the states and initialize state machine
	for state in sm.get_children():
		state.character = character
		state.animation_player = animation_player
		state.player = player
		state.visual = visual
		state.SPEED = SPEED
	sm.init()

func _physics_process(delta: float) -> void:
	#gravity
	velocity += get_gravity() * delta
	#move
	move_and_slide()

func die() -> void:
	var current_state_name = sm.get_current_state().name
	if current_state_name != "die":
		sm.force_state("die")


func _on_grab_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
