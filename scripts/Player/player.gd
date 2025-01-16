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
var is_in_water: bool = false
var was_moving: bool = false  # Tracks whether the player was moving in the last frame


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
	# Bug fix for swim
	if not is_in_water and player.character == "Black" and %Skeleton3D.position != Vector3.ZERO:
		%Skeleton3D.position = %Skeleton3D.position.lerp(Vector3.ZERO, 5 * delta)
	#gravity
	velocity += get_gravity() * delta
	#fall death
	if global_transform.origin.y < fall_threshold:
		spawn_player()
		spawn_throwable()

	move_and_slide()

func spawn_player():
	velocity = Vector3.ZERO
	global_transform.origin = spawn_position
	reset()

func spawn_throwable():
	if character == "White": return
	if $Grab.throawable == null: return
	$Grab.reset_respawn()

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
	
func set_is_in_water(value:bool) -> void:
	is_in_water = value


##AUDIO##

func play_walk_r() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Move_r)

func play_walk_l() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Move_l)

func play_push() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Push)

func play_move_w() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Move_w)
