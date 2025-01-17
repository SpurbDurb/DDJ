extends Node3D

@onready var camera_mount: SpringArm3D = $camera_mount
@onready var camera_3d: Camera3D = $camera_mount/Camera3D

# Jogadores
var player: Node = null
var player_2: Node = null

# camera events -----
var in_goal := false

var in_event:= false
var event_global_position : Vector3
@export var camera_event_speed: float = 0.05
@export var event_zoom: float = 2.8
# camera events -----

# Parâmetros de zoom
@export var min_zoom: float = 8.0
@export var max_zoom: float = 0.8
# Parâmetros de altura
@export var min_height: float = 1.2
@export var max_height: float = 2.0
# Parâmetros de anglo
@export var min_angle: float = -40.0
@export var max_angle: float = -25.0
# Speed
@export var zoom_speed: float = 0.05
@export var camera_speed: float = 0.07
@export var max_rotation_speed: float = 0.2
@export var min_rotation_speed: float = 0.01


func _ready() -> void:
	# Listen for spawned players
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	
	# Connect to signals for camera events
	SignalManager.connect("camera_event", Callable(self, "_on_camera_event"))

	
func _on_node_added(node: Node) -> void:
	if node.name == "Player_W":
		player = node
	elif node.name == "Player_B":
		player_2 = node
		
	if player != null and player_2 != null:
		_physics_process(0)  # Run physics processing again

func _on_camera_event(global_position_for_event: Vector3):
	event_global_position = global_position_for_event
	in_event = true

func _physics_process(_delta: float) -> void:
	if player == null: player = get_node_or_null("../Player_W")
	if player_2 == null: player_2 = get_node_or_null("../Player_B")
	if player == null or player_2 == null: return
	
	if in_event:
		handle_event(_delta)
		return
	
	handle_players(_delta)

func handle_players(_delta: float) -> void:
	var player_distance = player.global_transform.origin.distance_to(player_2.global_transform.origin)
	
	# Posição central dos dois jogadores
	var center_position = (player.global_transform.origin + player_2.global_transform.origin) / 2.0
	global_transform.origin = lerp(global_transform.origin, center_position, camera_speed)
	
	# Rotação da câmera
	#var direction = (player_2.global_transform.origin - player.global_transform.origin).normalized()
	#var target_rotation_y = atan2(direction.x, direction.z) + PI / 2
	#var current_rotation_y = rotation.y
	#var rotation_speed = clamp(player_distance / 100, min_rotation_speed, max_rotation_speed)
	#rotation.y = lerp_angle(current_rotation_y, target_rotation_y, rotation_speed / 10)
	
	# Ajusta o zoom dinamicamente com base na distância
	var target_zoom = clamp(player_distance, max_zoom, min_zoom,)
	camera_mount.spring_length = lerp(camera_mount.spring_length, target_zoom, zoom_speed)
	
	# Ajusta a altura da câmera dinamicamente com base na distância
	if not in_goal:
		var target_height = clamp(player_distance, min_height, max_height)
		camera_mount.position.y = lerp(camera_mount.position.y, target_height, zoom_speed)
	else:
		camera_mount.position.y = lerp(camera_mount.position.y, 1.5, zoom_speed)
	
	# Ajusta o ângulo da câmera dinamicamente com base na distância
	if not in_goal:
		var angle_range = deg_to_rad(max_angle - min_angle)  # Intervalo em radianos
		var normalized_distance = clamp(player_distance / min_zoom, 0, 1)  # Normaliza entre 0 e 1
		var target_angle = deg_to_rad(min_angle) + normalized_distance * angle_range  # Calcula o ângulo com base na distância
		# Suaviza a rotação no eixo X
		camera_3d.rotation.x = lerp(camera_3d.rotation.x, target_angle, zoom_speed)
	if in_goal:
		camera_3d.rotation.x = lerp(camera_3d.rotation.x, deg_to_rad(-15.0), zoom_speed)

func handle_event(_delta: float) -> void:
	# Move the camera towards the event_global_position
	global_transform.origin = lerp(global_transform.origin, event_global_position, camera_speed)
	# Ajusta o zoom 
	camera_mount.spring_length = lerp(camera_mount.spring_length, event_zoom , zoom_speed)

	# Check if the camera is close enough to the event position
	if global_transform.origin.distance_to(event_global_position) < 0.05:
		# End the event
		in_event = false
