extends Area3D

# floating physics
@export var float_force := 20
@export var water_drag := 0.1
@export var water_angular_drag := 0.1

var water_height := 0.0
var water_height_offset = 0.5

var player_in_water: bool = false
var submerged: bool = false
var objects_in_water = []  

func _ready():
	water_height = global_position.y + water_height_offset

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("FloatingObject"):
		objects_in_water.append(body)
		if not body.is_in_group("Player"):
			AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Land_w)
	if body.is_in_group("Player"):
		handle_player_on_water(body)
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Land_w)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player") and body.character == "Black":
		body.set_is_in_water(false)
	if body in objects_in_water:
		objects_in_water.erase(body)

func handle_player_on_water(body: PhysicsBody3D) -> void:	
	var depth = water_height - body.global_position.y
	if depth <= 0: return # podem tocar na agua sem mudar o estado
	
	if body.character == "Black":
		#AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Move_w)
		body.set_is_in_water(true)
		
	elif body.character == "White":
		body.call_deferred("die")

func _physics_process(delta: float) -> void:
	for body in objects_in_water:
		if body is RigidBody3D:
			apply_buoyancy_and_drag_to_rigidbody(body)
		elif body is CharacterBody3D:
			if body.is_in_group("Player"):
				apply_buoyancy_and_drag_to_character(delta, body, 0.8, 0.7)
			else:
				apply_buoyancy_and_drag_to_character(delta, body, 1, 0.6)

func apply_buoyancy_and_drag_to_rigidbody(body: RigidBody3D) -> void:
	var depth = water_height - body.global_position.y
	if depth > 0: 
		var upward_force = Vector3.UP * float_force * depth
		body.apply_central_force(upward_force)  
		body.linear_velocity *= 1.0 - water_drag
		body.angular_velocity *= 1.0 - water_angular_drag

func apply_buoyancy_and_drag_to_character(delta: float, body: CharacterBody3D, y_drag, character_mass) -> void:
	var depth = water_height - body.global_position.y
	if depth < 0:  return
	
	var upward_force = float_force * depth * 3
	# Counteract gravity explicitly
	var gravity_force = ProjectSettings.get_setting("physics/3d/default_gravity") * character_mass
	var net_upward_force = upward_force - gravity_force
	# Apply the net buoyancy to vertical velocity
	body.velocity.y += net_upward_force * delta
	# Apply drag selectively
	var drag_factor = 1.0 - water_drag
	body.velocity.x *= drag_factor
	body.velocity.z *= drag_factor
	# Apply less drag to vertical velocity to preserve buoyancy
	body.velocity.y *= 1.0 - (water_drag * y_drag)
