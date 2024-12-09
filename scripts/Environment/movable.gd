extends CharacterBody3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
var pushing := false
const atrito := 2

func _physics_process(delta: float) -> void:
	#gravity
	velocity += get_gravity() * delta
	#rotate collision_shape_3d
	collision_shape_3d.rotation_degrees.x = velocity.z * 5
	collision_shape_3d.rotation_degrees.z = velocity.x * 5
	#stop
	if not pushing:
		velocity.x = move_toward(velocity.x, 0, atrito)
		velocity.z = move_toward(velocity.z, 0, atrito)
		#rotation = Vector3.ZERO
	#move
	move_and_slide()
