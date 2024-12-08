extends StaticBody3D

signal entered
signal exited

@export_range(1,9) var connection_id: int = 1
@export var multiple: bool = false
@export var one_time: bool = false
@export var call_back: bool = false
@export var texture: Texture

@onready var press: MeshInstance3D = $press
@onready var area_3d: Area3D = $Area3D
@onready var anim = $AnimationPlayer
var is_pressed = false
var locked = false

func _ready() -> void:
	if texture: change_texture(texture)
	if multiple: return
	
	SignalManager.register_signal(connection_id)
	if call_back: 
		locked = true
		SignalManager.connect_to_signal(connection_id, Callable(self, "_on_connection_triggered"))

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if is_pressed: return
	if call_back: 
		locked = true
	is_pressed = true
	anim.play("pressdown")
	
	if multiple: 
		emit_signal("entered")
		return
	
	SignalManager.emit_connection_signal(connection_id, self)

func _on_area_3d_body_exited(_body: Node3D) -> void:
	if locked or one_time or not is_pressed: return
	if area_3d.get_overlapping_bodies().size() != 0: return
	
	is_pressed = false
	anim.play("pressup")
	
	if multiple: 
		emit_signal("exited")
		return
	
	SignalManager.emit_connection_signal(connection_id, self)

func _on_connection_triggered() -> void:
	locked = false
	_on_area_3d_body_exited(null)


#MUDANCA DE TEXTURA
func change_texture(new_texture: Texture) -> void:
	if press and press.mesh:
		# Duplicate the mesh to create a unique instance
		var unique_mesh = press.mesh.duplicate()
		press.mesh = unique_mesh
		
		# Create a new material with the texture
		var material = StandardMaterial3D.new()
		material.albedo_texture = new_texture
		
		# Apply the material to the first surface of the unique mesh
		unique_mesh.surface_set_material(0, material)
