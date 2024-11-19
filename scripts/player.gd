extends CharacterBody3D

@onready var camera_mount = $camera_mount
@onready var camera = $camera_mount/Camera3D
@onready var visual = $visual/stickman
@onready var animation_player = $visual/stickman/AnimationPlayer
var jumping = false

@export var SENS = 0.04
const SPEED = 2.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#camera.look_at(Vector3.ZERO, Vector3.UP)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENS))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		jumping = true
		animation_player.play("air")
		velocity += get_gravity() * delta
	else:
		jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jumping = true
		animation_player.play("jump")
		velocity.y = SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if animation_player.current_animation != "run" && !jumping:
			animation_player.play("run")
		visual.look_at(position - direction)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idle" && !jumping:
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	move_and_slide()
