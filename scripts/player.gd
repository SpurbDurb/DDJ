extends CharacterBody3D

@onready var state_machine = $"state machine"

@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6
@export var SENS = 0.04

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	
	# Assign the shared data to the state
	for state in state_machine.get_children():
		state.animation_player = animation_player
		state.player = player
		state.visual = visual
		state.SPEED = SPEED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENS))

#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#jumping = true
		#animation_player.play("air")
		#velocity += get_gravity() * delta
	#else:
		#jumping = false
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#jumping = true
		#animation_player.play("jump")
		#velocity.y = SPEED
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("left", "right", "forward", "backward")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#if animation_player.current_animation != "run" && !jumping:
			#animation_player.play("run")
		#visual.look_at(position - direction)
		#
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#if animation_player.current_animation != "idle" && !jumping:
			#animation_player.play("idle")
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
#
	#move_and_slide()
