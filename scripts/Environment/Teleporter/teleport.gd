extends Node3D

@export var manager: Node
@onready var animation_player: AnimationPlayer = $Beam/AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	manager.call("handle_body_entered", self, body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	manager.call("handle_body_exited", self, body)
