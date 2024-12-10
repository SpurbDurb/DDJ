extends RigidBody3D
class_name Throwable

@export var fall_threshold: float = -10.0  
var spawn_position: Vector3 
var spawn_offset: Vector3 = Vector3(0, 0.2, 0) 
var pls_spawn := false
var spawnig := false

func _ready() -> void:
	spawn_position = global_transform.origin + spawn_offset

func _process(_delta):
	if pls_spawn or global_transform.origin.y < fall_threshold:
		linear_velocity = Vector3.ZERO
		global_transform.origin = spawn_position
		pls_spawn = false
		spawnig = true

func respawn():
	pls_spawn = true
