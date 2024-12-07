extends Area3D

@export var throw_force: float = 1.5
@export var throw_direction: Vector3 = Vector3.FORWARD

var throwable: Object
var offset_from_head: Vector3 = Vector3(0, 0.8, 0)  # The offset to carry the object above the player

func throw_object(obj: Node3D) -> void:
	if obj:
		if obj and obj is RigidBody3D:
			obj.freeze = false
			var linear_velocity = throw_direction * throw_force
			obj.linear_velocity = linear_velocity
			obj.apply_central_impulse(throw_direction * throw_force)
			print("Object thrown with ", linear_velocity)
			throwable = null
		else:
			print("No RigidBody3D found to apply physics")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Throwable"):
		throwable = body
		print("Throwable object detected")
		_carry_object(throwable)

func _carry_object(obj: Node3D) -> void:
	var holder_position = global_transform.origin
	var new_position = holder_position + offset_from_head

	obj.global_transform.origin = new_position
	obj.rotation = Vector3(0, 0, 0)

func _process(delta: float) -> void:
	if throwable:
		# Continuously update the object's position while carrying
		var new_position = global_transform.origin + offset_from_head
		throwable.global_transform.origin = new_position
		
		# Set the object's rotation to 0,0,0 while carrying
		throwable.rotation = Vector3(0, 0, 0)

		if Input.is_action_just_pressed("throw"):
			throw_object(throwable)
