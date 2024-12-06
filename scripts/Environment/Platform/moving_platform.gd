extends Node3D

@export_range(1,9) var connection_id: int = 1
@export var active: bool = true
@export var reset: bool = false

enum Direction { Horizontal, Vertical }
@export var direction: Direction = Direction.Horizontal
@export var speed: float = 1.0  # Velocidade da plataforma
@export var distance: float = 5.0  # Distância da plataforma
@export var pause_duration: float = 1.0  # Tempo de pausa nas extremidades

var initial_position: Vector3
var moving_forward: bool = true
var is_paused: bool = false 
var reset_lock: bool = false 
var go_back: bool = false 

@onready var pause_timer: Timer = Timer.new()

func _ready() -> void:
	initial_position = global_transform.origin
	
	if not active:
		SignalManager.connect_to_signal(connection_id, Callable(self, "_on_connection_triggered"))
	
	if reset: return
	# Configura o temporizador
	pause_timer.wait_time = pause_duration
	pause_timer.one_shot = true
	pause_timer.connect("timeout", Callable(self, "_on_pause_timer_timeout"))
	add_child(pause_timer)

func _on_connection_triggered():
	active = not active
	if not active and reset: 
		go_back = not go_back
		reset_lock = false

func _physics_process(delta: float) -> void:
	if not go_back and (reset_lock or is_paused or not active):return
	
	var local_displacement = get_local_displacement(delta)
	var global_displacement = transform.basis * local_displacement
	global_transform.origin += global_displacement

	var traveled_distance = global_transform.origin.distance_to(initial_position)
	if go_back and traveled_distance <= 0.01:
		go_back = false
		is_paused = false
		moving_forward = true
	elif traveled_distance >= distance:
		if reset:
			moving_forward = !moving_forward
			initial_position = global_transform.origin
			reset_lock = true
		else:
			is_paused = true
			pause_timer.start()

func get_local_displacement(delta: float):
	var displacement
	if go_back:
		var direction_to_initial = (initial_position - global_transform.origin).normalized()
		displacement = speed * delta
		return direction_to_initial * displacement
	
	displacement = speed * delta
	if not moving_forward:
		displacement = -displacement
		
	var local_displacement = Vector3.ZERO
	if direction == Direction.Horizontal:
		local_displacement = Vector3(displacement, 0, 0)
	elif direction == Direction.Vertical:
		local_displacement = Vector3(0, displacement, 0)
	return local_displacement

func _on_pause_timer_timeout() -> void:
	# Altera a direção e remove a pausa
	moving_forward = !moving_forward
	initial_position = global_transform.origin
	is_paused = false
