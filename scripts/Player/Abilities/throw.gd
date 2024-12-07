extends Area3D

@export var throw_force: float = 1.6
@export var up_force: float = 1
@export var player : CharacterBody3D
@export var pause_duration: float = 0.8

@onready var pause_timer: Timer = Timer.new()
var throawable: Object
var offset_from_head: Vector3 = Vector3(0, 0.7, 0) 
var target_position

func _ready() -> void:
	# Configura o temporizador
	pause_timer.wait_time = pause_duration
	pause_timer.one_shot = true
	pause_timer.connect("timeout", Callable(self, "_on_pause_timer_timeout"))
	add_child(pause_timer)

func _on_pause_timer_timeout() -> void:
	monitoring = true
	
func throw_object() -> void:
	throawable.sleeping = false 
	throawable.gravity_scale = 1
	
	var throw_direction = -player.transform.basis.z + Vector3(0, 1, 0) * up_force
	throw_direction = throw_direction.normalized()

	var linear_velocity = throw_direction * throw_force
	throawable.linear_velocity = linear_velocity
	throawable.apply_central_impulse(throw_direction * throw_force)

	throawable = null
	pause_timer.start()

func _on_body_entered(body: Node3D) -> void:
	if throawable: return
	if body.is_in_group("Throwable"):
		throawable = body
		throawable.sleeping = true
		throawable.gravity_scale = 0
		throawable.rotation = Vector3(0, 0, 0)
		set_deferred("monitoring", false)

func _process(_delta: float) -> void:
	if not throawable: return
	if throawable.is_in_group("Key") and throawable.used:
		throawable = null
		return 
	
	#update position
	target_position = global_transform.origin + offset_from_head
	throawable.global_transform.origin = throawable.global_transform.origin.lerp(target_position, 0.2)
	if Input.is_action_just_pressed("throw"):
		throw_object()
