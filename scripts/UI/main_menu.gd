extends CanvasLayer

func _ready() -> void:
	AudioManager.reset()

func play():
	SceneManager.switch_scene("res://scenes/Level/Level System/base.tscn")
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Button_pressed)
