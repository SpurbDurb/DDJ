extends Node3D

@onready var laser = $Laser
@onready var moving_barrier = $Barrier2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser.activate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	laser.look_at(moving_barrier.position)
	laser.rotation_degrees.x = 90
