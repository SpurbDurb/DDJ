extends Node3D
signal entered_goal
signal exited_goal

var lock := false
var player_count := 0

@export var duration: float = 10  #(duration of the tween)
@onready var distance  = LevelManager.level_up_offset
var initial_position: Vector3
var target_position: Vector3
var tween

func _move() -> void:
	# Update positions
	initial_position = global_transform.origin
	target_position = initial_position + Vector3(0, distance, 0)

	# Start moving with Tween
	tween = create_tween()
	tween.tween_property(self, "global_position", target_position, duration)
	tween.set_trans(Tween.EASE_IN_OUT)
	tween.tween_callback(_on_tween_finished)

func _on_tween_finished():
	emit_signal("exited_goal")
	lock = true
	tween.kill()


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
