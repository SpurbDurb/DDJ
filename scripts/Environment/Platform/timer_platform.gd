extends Node3D

@export_range(1, 9) var connection_id: int = 1
@export var is_viseble: bool = false

@onready var body: CharacterBody3D = $Body3D
@onready var collision: CollisionShape3D = $Body3D/CollisionShape3D
@onready var csg_box_3d: CSGBox3D = $Body3D/CSGBox3D
@onready var visibility_timer: Timer = Timer.new()

var current_alpha: float = 0.0  # Transparência atual do material
var target_alpha: float = 0.0  # Transparência alvo
@export var fade_speed: float = 5.0  # Velocidade da transição
@export var visible_duration: int = 5

var locked: bool = false

func _ready() -> void:
	# Cria uma instância única do material para evitar partilha
	if csg_box_3d.material:
		csg_box_3d.material = csg_box_3d.material.duplicate()
	
	body.visible = is_viseble
	collision.disabled = not is_viseble
	reset_alpha()
	
	# Conecta e regista sinal
	SignalManager.connect_to_signal(connection_id, Callable(self, "_on_connection_triggered"))
	SignalManager.register_signal(connection_id)
	
	# Temporizador da plataforma visivel
	add_child(visibility_timer)
	visibility_timer.one_shot = true
	visibility_timer.connect("timeout", Callable(self, "_on_visibility_timeout"))

func _on_connection_triggered():
	if locked: return
	print("entrou")
	locked = true
	visibility_timer.start(visible_duration) 
	switch_visibility()

func _process(delta: float) -> void:
	# Faz a transição de transparência com `lerp`
	if abs(current_alpha - target_alpha) < 0.1:
		body.visible = is_viseble
		collision.disabled = not is_viseble
		reset_alpha()
	else:
		current_alpha = lerp(current_alpha, target_alpha, fade_speed * delta)
		if csg_box_3d.material:
			csg_box_3d.material.albedo_color.a = current_alpha

func _on_visibility_timeout():
	print("saiu")
	SignalManager.emit_connection_signal(connection_id)
	locked = false
	switch_visibility()

func switch_visibility():
	if is_viseble:
		target_alpha = 0.0
	else:
		target_alpha = 1.0
	is_viseble = not is_viseble
	
	if is_viseble:
		body.visible = true

func reset_alpha():
	# Reinicia o alpha para o estado atual
	if is_visible:
		current_alpha = 1.0
		target_alpha = 1.0
	else:
		current_alpha = 0.0
		target_alpha = 0.0
