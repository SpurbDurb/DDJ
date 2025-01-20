extends Node

@export var teleporter_1: Node3D
@export var teleporter_2: Node3D

var player_1: CharacterBody3D = null
var player_2: CharacterBody3D = null
var player_count := 0
var audio_playing := false
#@onready var animation_player: AnimationPlayer = $Teleporter_1/Beam/AnimationPlayer

@onready var teleporter_1_animation: AnimationPlayer = teleporter_1.get_node("Beam/AnimationPlayer")
@onready var teleporter_2_animation: AnimationPlayer = teleporter_2.get_node("Beam/AnimationPlayer")

func handle_body_entered(teleporter: Node3D, body: Node3D) -> void:
	if body and body.is_in_group("Player"):
		player_count = min(2,player_count +1)
		if teleporter == teleporter_1:
			player_1 = body
			teleporter_1_animation.play("start")
		elif teleporter == teleporter_2:
			player_2 = body
			teleporter_2_animation.play("start")
		
		if player_count == 2:
			teleport_players()
		if not audio_playing:
			audio_playing = true
			AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.TP_start)

func handle_body_exited(teleporter: Node3D, body: Node3D) -> void:
	if body and body.is_in_group("Player"):
		player_count = max(0,player_count -1)
		if teleporter == teleporter_1:
			player_1 = null
			teleporter_1_animation.play("stop")
		elif teleporter == teleporter_2:
			player_2 = null
			teleporter_2_animation.play("stop")
	
		if audio_playing and player_count == 0:
			audio_playing = false
			AudioManager.fade_out_audio(SoundEffect.SOUND_EFFECT_TYPE.TP_start)

func teleport_players() -> void:
	player_count = 0
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
