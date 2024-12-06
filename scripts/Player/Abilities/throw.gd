extends Area3D

@export var throw_force: float = 10.0
@export var throw_direction: Vector3 = Vector3.FORWARD
var throwable : Object 

func throw_object(obj: Node3D) -> void:
	var rigid_body: RigidBody3D = obj as RigidBody3D	
	if rigid_body:
		var force = throw_direction.normalized() * throw_force
		rigid_body.apply_impulse(Vector3.ZERO, force)
		print("Object thrown with force: %s" % force)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Throwable"):
		throwable = body 
		print("Throwable object detected")
