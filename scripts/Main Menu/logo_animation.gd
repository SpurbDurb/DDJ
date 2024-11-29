extends TextureRect

@export var amplitude = 15.0
@export var duration = 2
@export var trans_type : Tween.TransitionType
@export var ease_type : Tween.EaseType
@onready var start_y = position.y
var end_y
var tween 

func _ready():
	end_y = start_y - amplitude
	tween = create_tween().set_ease(ease_type).set_trans(trans_type).set_loops()
		# Animate up.
	tween.tween_property(
		self, "position:y", end_y, duration
	)
	# Animate back down after.
	tween.tween_property(
		self, "position:y", start_y, duration
	)
