extends Node3D

@export_range(1,9) var connection_id: int = 1
@export var beam_size := 2.5
@export var activated: bool = true

@onready var beam: RayCast3D = $Beam
@onready var beam_2: RayCast3D = $Beam2
@onready var moving_barrier = $Barrier2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beam.target_position.y = -beam_size
	beam_2.target_position.y = beam_size
	if activated: 
		beam.activate()
		beam_2.activate()
	else: 
		beam.deactivate()
		beam_2.deactivate()
	
	SignalManager.connect_to_signal(connection_id, Callable(self, "_on_connection_triggered"))

func _on_connection_triggered():
	if activated: 
		beam.deactivate()
		beam_2.deactivate()
		activated = false
	else:
		beam.activate()
		beam_2.activate()
		activated = true

func _process(_delta: float) -> void:
	beam.look_at(moving_barrier.global_position)
	beam.rotation_degrees.x = 90
	
	beam_2.look_at(moving_barrier.global_position)
	beam_2.rotation_degrees.x = 90
