extends Button

@export var trans_type : Tween.TransitionType
@export var ease_type : Tween.EaseType
@export var hover_scale = 1.1
var tween_scale

func _ready() -> void:
	call_deferred("setup")

func setup() -> void:
	self.pivot_offset = self.size/2

func _on_mouse_entered() -> void:
	if tween_scale and tween_scale.is_running():
		tween_scale.kill()
	tween_scale = create_tween().set_ease(ease_type).set_trans(trans_type)
	tween_scale.tween_property(self, "scale", Vector2(hover_scale, hover_scale), 0.5)
	
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.Button_hover)

func _on_mouse_exited() -> void:
	if tween_scale and tween_scale.is_running():
		tween_scale.kill()
	tween_scale = create_tween().set_ease(ease_type).set_trans(trans_type)
	tween_scale.tween_property(self, "scale", Vector2.ONE, 0.55)
