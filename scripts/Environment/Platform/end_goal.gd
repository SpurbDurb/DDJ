extends CSGBox3D

var lock := false
var player_count := 0

@export var speed: float = 3.0
var initial_position: Vector3
var target_position: Vector3
var moving := false

func _ready() -> void:
	initial_position = global_transform.origin
	target_position = initial_position + Vector3(0, 30, 0)

func reset() -> void:
	lock = false
	player_count = 0

func _physics_process(delta: float) -> void:
	if moving:
		# Calculate the direction vector and normalize it
		var direction = (target_position - global_transform.origin).normalized()
		
		# Move the node toward the target position
		global_transform.origin += direction * speed * delta

		if global_transform.origin.distance_to(target_position) <= speed * delta:
			moving = false

func _move() -> void:
	moving = true  # Start moving
	SignalManager.emit_camera_end_goal_event()

func _on_move_finished():
	lock = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if lock: return
	if body.is_in_group("Player"):
		player_count = clamp(player_count + 1, 0, 2)
	if player_count == 2:
		_move()
		lock = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if lock: return
	if body.is_in_group("Player"):
		player_count = clamp(player_count - 1, 0, 2)
