extends Area3D

@export var b_player: CharacterBody3D
@export var w_player: CharacterBody3D
# floating physics
@export var float_force := 25.0
@export var water_drag := 0.05
@export var water_angular_drag := 1

@onready var water_height := 0.0

var player_in_water: bool = false
var submerged: bool = false
var objects_in_water = []  

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("FloatingObject"):
		objects_in_water.append(body)
	if body.is_in_group("Player"):
		handle_player_on_water(body)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player") and body.name == "Player_B":
		# atualizar a flag para o estado do jogador mudar
		b_player.set_is_in_water(false)
	if body in objects_in_water:
		objects_in_water.erase(body)
		if body == b_player or body == w_player:
			body.set_is_in_water(false)

func handle_player_on_water(body: PhysicsBody3D) -> void:	
	var depth = water_height - body.global_position.y
	if depth <= 0:
		return # podem tocar na agua sem mudar o estado
	if body.name == "Player_B":
		# atualizar a flag para o estado do jogador mudar
		b_player.set_is_in_water(true)
	elif body.name == "Player_W": 
		# o jogador branco morre em agua
		await get_tree().create_timer(0.2).timeout
		w_player.die()
		
func _physics_process(delta: float) -> void:
	for body in objects_in_water:
		if body is RigidBody3D:
			apply_buoyancy_and_drag_to_rigidbody(body)
		elif body is CharacterBody3D:
			apply_buoyancy_and_drag_to_character(body)
			
func apply_buoyancy_and_drag_to_rigidbody(body: RigidBody3D) -> void:
	var depth = water_height - body.global_position.y
	if depth > 0: 
		var upward_force = Vector3.UP * float_force * depth
		body.apply_central_force(upward_force)  
		body.linear_velocity *= 1.0 - water_drag
		body.angular_velocity *= 1.0 - water_angular_drag

# Define a mass constant for the character (tune this value)
var character_mass = 1.0
func apply_buoyancy_and_drag_to_character(body: CharacterBody3D) -> void:
	var depth = water_height - body.global_position.y
	if depth > 0:  # If submerged
		# Calculate buoyancy force
		var upward_force = float_force * depth * 6 

		# Counteract gravity explicitly
		var gravity_force = ProjectSettings.get_setting("physics/3d/default_gravity") * character_mass
		var net_upward_force = upward_force - gravity_force

		# Apply the net buoyancy to vertical velocity
		body.velocity.y += net_upward_force * get_process_delta_time()

		# Apply drag selectively
		var drag_factor = 1.0 - water_drag
		body.velocity.x *= drag_factor
		body.velocity.z *= drag_factor

		# Apply less drag to vertical velocity to preserve buoyancy
		body.velocity.y *= 1.0 - (water_drag * 0.5)
