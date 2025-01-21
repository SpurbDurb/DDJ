extends Node

const EQUATORIAL_COMPLEX = preload("res://assets/Audio/music/Equatorial Complex.mp3")
const SPACE_JAZZ = preload("res://assets/Audio/music/Space Jazz.mp3")
var sound_effect_dict: Dictionary = {}
var active_audio_players: Dictionary = {}
@export var sound_effects: Array[SoundEffect]

func _ready() -> void:
	for sound_effect: SoundEffect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect
	play_music(EQUATORIAL_COMPLEX, "Music", -18, 30)

func play_music(audio_stream: AudioStream, bus_name: String, volume: int, delay: float) -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = audio_stream
	music_player.bus = bus_name
	music_player.autoplay = false
	music_player.volume_db = volume
	music_player.play()
	
	music_player.finished.connect(func() -> void:
		start_delayed_loop(music_player, delay)
	)

func start_delayed_loop(music_player: AudioStreamPlayer, delay: float) -> void:
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = delay
	timer.one_shot = true
	timer.connect("timeout", func() -> void:
		music_player.play()
		timer.queue_free()
	)
	timer.start()

func create_audio(type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_audio)
			new_audio.stream = sound_effect.sound_effect
			new_audio.volume_db = sound_effect.volume - (sound_effect.audio_count * 3)
			new_audio.pitch_scale = sound_effect.pitch_scale + randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
			new_audio.bus = sound_effect.bus
			new_audio.finished.connect(sound_effect.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
			
			if not active_audio_players.has(type):
				active_audio_players[type] = []
			active_audio_players[type].append(new_audio)
	else:
		push_error("Audio Manager failed to find setting for type ", type)

func fade_out_audio(type: SoundEffect.SOUND_EFFECT_TYPE, duration: float = 1.0) -> void:
	# Early return if the type doesn't exist in active_audio_players
	if not active_audio_players.has(type):
		push_warning("No active audio players found for type: %s" % type)
		return
	
	# Clean up invalid players first
	var valid_players: Array = []
	for player in active_audio_players[type]:
		if is_instance_valid(player) and not player.is_queued_for_deletion() and player.playing:
			valid_players.append(player)
	
	# Update the active_audio_players list with only valid players
	active_audio_players[type] = valid_players
	
	# If no valid players remain, clean up and return
	if valid_players.is_empty():
		if sound_effect_dict.has(type):
			sound_effect_dict[type].change_audio_count(0) # Reset the count
		push_warning("No valid audio players to fade for type: %s" % type)
		return
	
	# Fade out valid players
	var steps = 10
	for audio_player in valid_players:
		var fade_timer = Timer.new()
		add_child(fade_timer)
		fade_timer.wait_time = duration / steps
		fade_timer.one_shot = false
		
		# Store initial volume and calculate step size
		var initial_volume = audio_player.volume_db
		var step_volume_decrease = (initial_volume + 80) / steps
		var step_count = 0
		
		fade_timer.timeout.connect(func() -> void:
			if not is_instance_valid(audio_player) or audio_player.is_queued_for_deletion():
				fade_timer.queue_free()
				return
				
			step_count += 1
			audio_player.volume_db -= step_volume_decrease
			
			if step_count >= steps or audio_player.volume_db <= -80:
				audio_player.stop()
				audio_player.queue_free()
				if sound_effect_dict.has(type):
					sound_effect_dict[type].change_audio_count(-1)
				active_audio_players[type].erase(audio_player)
				fade_timer.queue_free()
		)
		
		fade_timer.start()
