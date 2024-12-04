extends StaticBody3D

@onready var area_3d: Area3D = $Area3D
@onready var anim = $AnimationPlayer
var is_pressed = false

@export var connection_id = 1

func _ready() -> void:
	SignalManager.register_signal(connection_id)

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if is_pressed: return
	
	is_pressed = true
	anim.play("pressdown")
	
	SignalManager.emit_connection_signal(connection_id)

func _on_area_3d_body_exited(_body: Node3D) -> void:
	if not is_pressed: return
	if area_3d.get_overlapping_bodies().size() != 0: return
	
	is_pressed = false
	anim.play("pressup")
	
	SignalManager.emit_connection_signal(connection_id)
