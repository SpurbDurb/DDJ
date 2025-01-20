extends Node3D

signal entered_goal
signal exited_goal

var lock := false
var player_count := 0

@export var speed: float = 3.0  # Movement speed (units per second)
var initial_position: Vector3
var target_position: Vector3
var moving := false

func _ready() -> void:
	initial_position = global_transform.origin
	target_position = initial_position + Vector3(0, LevelManager.level_up_offset, 0)

func _physics_process(delta: float) -> void:
	if moving:
		# Calculate the direction vector and normalize it
		var direction = (target_position - global_transform.origin).normalized()
		
		# Move the node toward the target position
		global_transform.origin += direction * speed * delta

		# Check if the target has been reached (or overshot)
		if global_transform.origin.distance_to(target_position) <= speed * delta:
			global_transform.origin = target_position  # Snap to the exact target position
			moving = false
			_on_move_finished()

func _move() -> void:
	moving = true  # Start moving
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Goal)

func _on_move_finished():
	AudioManager.fade_out_audio(SoundEffect.SOUND_EFFECT_TYPE.Goal)
	emit_signal("exited_goal")
	lock = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if lock: return
	if body.is_in_group("Player"):
		player_count = clamp(player_count + 1, 0, 2)
	if player_count == 2:
		emit_signal("entered_goal")
		lock = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if lock: return
	if body.is_in_group("Player"):
		player_count = clamp(player_count - 1, 0, 2)
