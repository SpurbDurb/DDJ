extends Control
signal okay

func _on_okay_pressed() -> void:
	emit_signal("okay")
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Button_pressed)
