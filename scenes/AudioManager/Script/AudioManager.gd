extends Node
## Editado apartir de: https://github.com/Aarimous/AudioManager

const EQUATORIAL_COMPLEX = preload("res://assets/Audio/music/Equatorial Complex.mp3")
const SPACE_JAZZ = preload("res://assets/Audio/music/Space Jazz.mp3")

var sound_effect_dict: Dictionary = {} ## Loads all registered SoundEffects on ready as a reference.

@export var sound_effects: Array[SoundEffect] ## Stores all possible SoundEffects that can be played.

func _ready() -> void:
	for sound_effect: SoundEffect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect
	play_music(EQUATORIAL_COMPLEX, "Music", -18, 30)


func play_music(audio_stream: AudioStream, bus_name: String, volume: int , delay: float) -> void:
	var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = audio_stream 
	music_player.bus = bus_name 
	music_player.autoplay = false 
	music_player.volume_db = volume
	music_player.play()
	
	# Connect to the 'finished' signal to restart the audio after a delay
	music_player.finished.connect(func() -> void:
		start_delayed_loop(music_player, delay)
	)

func start_delayed_loop(music_player: AudioStreamPlayer, delay: float) -> void:
	var timer: Timer = Timer.new()
	add_child(timer) # Add the Timer to the scene
	timer.wait_time = delay # Set the delay time (in seconds)
	timer.one_shot = true # Ensure the timer only runs once
	timer.connect("timeout", func() -> void:
		music_player.play() # Restart the audio after the delay
		timer.queue_free() # Free the timer after it is no longer needed
	)
	timer.start() # Start the timer

## Creates a sound effect if the limit has not been reached. Pass [param type] for the SoundEffect to be queued.
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
			
	else:
		push_error("Audio Manager failed to find setting for type ", type)
