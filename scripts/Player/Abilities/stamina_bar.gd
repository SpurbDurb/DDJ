extends Sprite3D

@export var player: Node3D
@export var progressBar: ProgressBar
@export var staminaIncreaseSpeed : int = 50
@export var staminaDecreaseSpeed : int = 50


@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var hide_stamina_bar_threshold: float = 2.0  


var hide_stamina_bar_timer: float = 0
var is_bar_visible: bool = false  
var is_progressing: bool = false

func _ready() -> void:
	modulate.a = 0
	hide()

func _process(delta: float) -> void:
	var is_player_state_run = player.get_current_state().name == "run"
	var is_player_state_die = player.get_current_state().name == "die"
	var is_player_sprinting = is_player_state_run and Input.is_action_pressed("sprint")
	if player:
		global_position = player.global_position

	if camera:
		look_at(camera.global_position, Vector3.UP)

	if is_player_sprinting:
		decrease_stamina_bar(delta)
		show_stamina_bar()
	elif is_player_state_die:
		fade_out_sprite(delta)
	else:
		fill_stamina_bar(delta)
		hide_stamina_bar(delta)

	update_visibility()

func fill_stamina_bar(delta: float) -> void:
	if progressBar.value < 100:
		progressBar.value += delta * staminaIncreaseSpeed
		if progressBar.value > 100:
			progressBar.value = 100

func decrease_stamina_bar(delta: float) -> void:
	if progressBar.value > 0:
		progressBar.value -= delta * staminaDecreaseSpeed
		if progressBar.value < 0:
			progressBar.value = 0

func show_stamina_bar() -> void:
	if not is_bar_visible:
		is_bar_visible = true
		show()
		modulate.a = 1  

func hide_stamina_bar(delta: float) -> void:
	if progressBar.value == 100:
		hide_stamina_bar_timer += delta
		if hide_stamina_bar_timer >= hide_stamina_bar_threshold:
			fade_out_sprite(delta)
	else:
		hide_stamina_bar_timer = 0  

func fade_out_sprite(delta: float) -> void:
	if modulate.a > 0:
		modulate.a -= delta * 5.0 
		if modulate.a <= 0:
			modulate.a = 0
			is_bar_visible = false
			hide()

func update_visibility() -> void:
	if not is_bar_visible:
		return

	if modulate.a <= 0:
		hide()
	else:
		show()
