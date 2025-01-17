extends StaticBody3D

@export var fade_speed: float = 5.0

@onready var lock: MeshInstance3D = $Lock
@onready var door: MeshInstance3D = $MeshInstance3D
var locked := true
var key: Object
var current_alpha: float = 1.0 
var offset_from_lock: Vector3 = Vector3(0, -0.1, 0) 
var lock_material
var door_material

func _ready() -> void:
	lock_material = lock.get_active_material(0).duplicate()
	lock.set_surface_override_material(0, lock_material)
	door_material = door.get_active_material(0).duplicate()
	door.set_surface_override_material(0, door_material)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Key"):
		key = body
		key.used = true
		key.freeze = true
		key.rotation = rotation
		set_deferred("monitoring", false)

func _process(delta: float) -> void:
	if not key: return
	
	var target_position = lock.global_transform.origin + offset_from_lock
	key.global_transform.origin = key.global_transform.origin.lerp(target_position, 0.1)
	
	if key.global_transform.origin.distance_to(lock.global_transform.origin) < 0.2:
		$CollisionShape3D.disabled = true
		current_alpha = lerp(current_alpha, 0.0, fade_speed * delta)
		lock_material.albedo_color.a = current_alpha
		door_material.albedo_color.a = current_alpha
	
	if current_alpha < 0.01:
		key.use()
		queue_free()
