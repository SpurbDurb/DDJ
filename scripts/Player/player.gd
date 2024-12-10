extends CharacterBody3D

@onready var sm: Node = $"state machine"

@export_enum("White", "Black")
var character: String = "White"
@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2
@export var SENS = 0.04
#Spawn
@export var fall_threshold: float = -10.0  
var spawn_position: Vector3 
var spawn_offset: Vector3 = Vector3(0, 0.5, 0) 
var spawn_protected: bool = false 
@onready var timer: Timer = Timer.new()
var spawn_cooldown = 1

func _ready() -> void:
	#Spawn
	spawn_position = global_transform.origin + spawn_offset
	#Timer
	timer.wait_time = spawn_cooldown
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_spawn_cooldown_end"))
	add_child(timer)

	# Assign the shared data to the states and initialize state machine
	for state in sm.get_children():
		state.character = character
		state.animation_player = animation_player
		state.player = player
		state.visual = visual
		state.SPEED = SPEED
	sm.init()

func _physics_process(delta: float) -> void:
	#gravity
	velocity += get_gravity() * delta
	#fall death
	if global_transform.origin.y < fall_threshold:
		velocity = Vector3.ZERO
		global_transform.origin = spawn_position
	#move
	move_and_slide()

func die() -> void:
	if spawn_protected: return
	spawn_protected = true
	timer.start()
	
	var current_state_name = sm.get_current_state().name
	if current_state_name != "die":
		sm.force_state("die")

func _on_spawn_cooldown_end () -> void:
	spawn_protected = false

func reset() -> void:
	var current_state_name = sm.get_current_state().name
	if current_state_name != "idle":
		sm.force_state("idle")

func get_current_state():
	return sm.get_current_state()
