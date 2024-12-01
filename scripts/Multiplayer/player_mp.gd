extends CharacterBody3D

@export var player_id := 1:
	set(id):
		player_id = id

@onready var sm = $"state machine"

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6
@export var SENS = 0.04


func _enter_tree() -> void:
	set_multiplayer_authority(player_id)

func _ready() -> void:
	if not is_multiplayer_authority(): return
	
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	
	# Assign the shared data to the states and initialize state machine
	for state in sm.get_children():
		state.animation_player = animation_player
		state.player = player
		state.visual = visual
		state.SPEED = SPEED
	sm.init()

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENS))

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	#gravity
	velocity += get_gravity() * delta
	#move
	move_and_slide()
