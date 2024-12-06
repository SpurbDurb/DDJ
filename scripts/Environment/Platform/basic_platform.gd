extends Node3D

@export_range(1, 9) var connection_id: int = 1
@export var is_viseble: bool = false

@onready var body: CharacterBody3D = $Body3D
@onready var collision: CollisionShape3D = $Body3D/CollisionShape3D
@onready var csg_box_3d: CSGBox3D = $Body3D/CSGBox3D

var current_alpha: float = 0.0  # Transparência atual do material
var target_alpha: float = 0.0  # Transparência alvo
@export var fade_speed: float = 5.0  # Velocidade da transição

func _ready() -> void:
	# Cria uma instância única do material para evitar partilha
	if csg_box_3d.material:
		csg_box_3d.material = csg_box_3d.material.duplicate()
	
	body.visible = is_viseble
	collision.disabled = not is_viseble
	reset_alpha()
	
	# Conecta ao sinal
	SignalManager.connect_to_signal(connection_id, Callable(self, "_on_connection_triggered"))

func _on_connection_triggered():
	# Alterna entre visível e invisível
	if is_viseble:
		target_alpha = 0.0
	else:
		target_alpha = 1.0
	is_viseble = not is_viseble
	
	if is_viseble:
		body.visible = true

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

func reset_alpha():
	# Reinicia o alpha para o estado atual
	if is_viseble:
		current_alpha = 1.0
		target_alpha = 1.0
	else:
		current_alpha = 0.0
		target_alpha = 0.0
