extends Node3D

@onready var beam: RayCast3D = $Beam
@onready var moving_barrier = $Barrier2

@export var activated: bool = true
@export var connection_id = 1 # Identificador da conexão

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if activated: beam.activate()
	else: beam.deactivate()
	
	SignalManager.connect_to_signal(connection_id, Callable(self, "_on_connection_triggered"))

func _on_connection_triggered():
	if activated: 
		beam.deactivate()
		activated = false
	else:
		beam.activate()
		activated = true

func activate():
	beam.activate()

func deactivate():
	beam.deactivate()

func _process(delta: float) -> void:
	beam.look_at(moving_barrier.global_position)
	beam.rotation_degrees.x = 90
