extends Throwable

@export var fade_speed: float = 5.0
@onready var key: MeshInstance3D = $key
var used := false
var destroy := false
var key_material
var current_alpha: float = 1.0 

func _ready() -> void:
	super()
	key_material = key.get_active_material(0).duplicate()
	key.set_surface_override_material(0, key_material)

func use():
	destroy = true

func _process(delta: float) -> void:
	super(delta)
	if not destroy: return

	current_alpha = lerp(current_alpha, 0.0, fade_speed * delta)
	key_material.albedo_color.a = current_alpha
	
	if current_alpha < 0.01:
		queue_free()
