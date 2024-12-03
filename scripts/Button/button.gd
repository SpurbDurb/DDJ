extends StaticBody3D

@onready var area_3d: Area3D = $Area3D
@onready var anim = $AnimationPlayer
var is_pressed = false

signal pressed
signal released

func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_pressed: return
	
	is_pressed = true
	anim.play("pressdown")
	pressed.emit()
	print("Pressed")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if not is_pressed: return
	if area_3d.get_overlapping_bodies().size() != 0: return
	
	is_pressed = false
	anim.play("pressup")
	released.emit()
	print("Released")
