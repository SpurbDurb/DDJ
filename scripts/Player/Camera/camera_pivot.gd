extends Node3D

@onready var camera_mount: SpringArm3D = $camera_mount
@onready var camera_3d: Camera3D = $camera_mount/Camera3D

# Jogadores
var player: Node = null
var player_2: Node = null
# Parâmetros de zoom
@export var min_zoom: float = 8.0
@export var max_zoom: float = 0.8
# Parâmetros de altura
@export var min_height: float = 1.0
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

	
func _on_node_added(node: Node) -> void:
	if node.name == "Player_W":
		player = node
	elif node.name == "Player_B":
		player_2 = node
		
	if player != null and player_2 != null:
		_physics_process(0)  # Run physics processing again


func _physics_process(_delta: float) -> void:
	if player == null:
		player = get_node_or_null("../Player_W")
	if player_2 == null:
		player_2 = get_node_or_null("../Player_B")
	if player == null or player_2 == null:
		return
	
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
	var target_height = clamp(player_distance, min_height, max_height)
	camera_mount.position.y = lerp(camera_mount.position.y, target_height, zoom_speed)
	
	# Ajusta o ângulo da câmera dinamicamente com base na distância
	var angle_range = deg_to_rad(max_angle - min_angle)  # Intervalo em radianos
	var normalized_distance = clamp(player_distance / min_zoom, 0, 1)  # Normaliza entre 0 e 1
	var target_angle = deg_to_rad(min_angle) + normalized_distance * angle_range  # Calcula o ângulo com base na distância
	# Suaviza a rotação no eixo X
	camera_3d.rotation.x = lerp(camera_3d.rotation.x, target_angle, zoom_speed)
