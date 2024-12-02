extends StaticBody3D


@onready var anim = $AnimationPlayer

signal pressed
signal released

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name != "ButCol": 
		anim.play("pressdown")
		pressed.emit()
		print("Pressed")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name != "ButCol": 
		anim.play("pressup")
		released.emit()
		print("Released")
