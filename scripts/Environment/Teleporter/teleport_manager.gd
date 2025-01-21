extends Node

@export var teleporter_1: Node3D
@export var teleporter_2: Node3D
@export var swap_spawns := false

var player_1: CharacterBody3D = null
var player_2: CharacterBody3D = null
var player_count := 0
var tping := 0
var audio_playing := false

@onready var teleporter_1_animation: AnimationPlayer = teleporter_1.get_node("Beam/AnimationPlayer")
@onready var teleporter_2_animation: AnimationPlayer = teleporter_2.get_node("Beam/AnimationPlayer")

func handle_body_entered(teleporter: Node3D, body: Node3D) -> void:
	if tping: return
	if body and body.is_in_group("Player"):
		player_count = min(2,player_count +1)
		if player_count != 2:
			audio_playing = true
			AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.TP_start)
		if teleporter == teleporter_1:
			player_1 = body
			teleporter_1_animation.play("start")
		elif teleporter == teleporter_2:
			player_2 = body
			teleporter_2_animation.play("start")
		
		if player_count == 2:
			teleport_players()
		

func handle_body_exited(teleporter: Node3D, body: Node3D) -> void:
	if tping: return
	if body and body.is_in_group("Player"):
		player_count = max(0,player_count -1)
		if audio_playing:
			audio_playing = false
			AudioManager.fade_out_audio(SoundEffect.SOUND_EFFECT_TYPE.TP_start)
		if teleporter == teleporter_1:
			player_1 = null
			teleporter_1_animation.play("stop")
		elif teleporter == teleporter_2:
			player_2 = null
			teleporter_2_animation.play("stop")

func teleport_players() -> void:
	tping = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.TP_end)
	if audio_playing:
		audio_playing = false
		AudioManager.fade_out_audio(SoundEffect.SOUND_EFFECT_TYPE.TP_start)
	teleporter_1_animation.play("stop")
	teleporter_2_animation.play("stop")

	# Swap player positions
	if player_1:
		var target_position = teleporter_2.global_transform.origin
		target_position.y = player_1.global_position.y
		player_1.global_position = target_position

	if player_2:
		var target_position = teleporter_1.global_transform.origin
		target_position.y = player_2.global_position.y
		player_2.global_position = target_position
	
	# Swap player spawns 
	if swap_spawns:
		var temp_spwan = player_1.spawn_position
		player_1.spawn_position = player_2.spawn_position
		player_2.spawn_position = temp_spwan
	
	# Swap player references
	var temp_player = player_1
	player_1 = player_2
	player_2 = temp_player
	
	var timer = Timer.new()
	timer.wait_time = 0.8
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_teleport_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_teleport_timer_timeout() -> void:
	tping = false
