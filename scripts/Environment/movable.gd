extends CharacterBody3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
var destroy := false
var pushing := false
const atrito := 2

#spawn
@export var fall_threshold: float = -10.0  
var spawn_position: Vector3 
var spawn_offset: Vector3 = Vector3(0, 0.2, 0) 

#destroy
@export var fade_speed: float = 5.0
@export  var mesh: MeshInstance3D
var material
var current_alpha: float = 1.0 

func _ready() -> void:
	spawn_position = global_transform.origin + spawn_offset
	material = mesh.get_active_material(0).duplicate()
	mesh.set_surface_override_material(0, material)

func _physics_process(delta: float) -> void:
	#gravity
	velocity += get_gravity() * delta
	#rotate collision_shape_3d
	collision_shape_3d.rotation_degrees.x = - velocity.z * 5.5
	collision_shape_3d.rotation_degrees.z = velocity.x * 5.5
	#stop
	if not pushing:
		velocity.x = move_toward(velocity.x, 0, atrito)
		velocity.z = move_toward(velocity.z, 0, atrito)
		rotation = Vector3.ZERO
	#move
	move_and_slide()

func _process(delta):
	if global_transform.origin.y < fall_threshold: spawn()

	#destroy
	if not destroy: return
	current_alpha = lerp(current_alpha, 0.0, fade_speed * delta)
	material.albedo_color.a = current_alpha
	if current_alpha < 0.01: spawn()

func spawn():
	velocity = Vector3.ZERO
	global_transform.origin = spawn_position
	
	material.albedo_color.a = 1
	destroy = false
	pushing = false
	current_alpha = 1.0 

func die():
	destroy = true
