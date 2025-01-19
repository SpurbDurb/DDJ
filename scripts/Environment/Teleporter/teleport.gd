extends Node3D

@export var target_teleporter: Node3D  
var can_teleport_again: bool = true       

func _on_area_3d_body_entered(body: Node3D) -> void:
	if can_teleport_again:
		if body and body.is_in_group("Player"):
			body.global_transform.origin = target_teleporter.global_transform.origin
			can_teleport_again = false
			target_teleporter.can_teleport_again=false

func _on_area_3d_body_exited(body: Node3D) -> void:
	can_teleport_again = true
