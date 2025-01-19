extends Node3D

var player: CharacterBody3D       

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body and body.is_in_group("Player"):
		player = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	player = null
	print("exit")
