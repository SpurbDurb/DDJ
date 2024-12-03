extends RayCast3D

@onready var beam_mesh = $BeamMesh
@onready var end_particles = $EndParticles
@onready var beam_particles = $BeamParticles

var tween : Tween
var beam_radius: float = 0.03
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	deactivate(1)
	await get_tree().create_timer(3.0).timeout
	activate(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cast_point
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y/2
		
		end_particles.position.y = cast_point.y
		
		var particle_amount = snapped(abs(cast_point.y)*50, 1)
		
		if particle_amount > 1:
			beam_particles.amount = particle_amount
		else: 
			beam_particles.amount = 1
			
		var material = beam_particles.process_material
		print(material)			
		material.emission_box_extents = Vector3(
			beam_mesh.mesh.top_radius,
			abs(cast_point.y) / 2,
			beam_mesh.mesh.top_radius
		)
	pass
func activate(time: float = 0.5):
	tween = get_tree().create_tween()
	visible = true
	beam_particles.emitting = true
	end_particles.emitting = true
	# Animate beam and particle properties
	tween.set_parallel(true)
	tween.tween_property(beam_mesh.mesh, "top_radius", beam_radius, time)
	tween.tween_property(beam_mesh.mesh, "bottom_radius", beam_radius, time)
	tween.tween_property(beam_particles.process_material, "scale_min", 1, time)
	tween.tween_property(end_particles.process_material, "scale_min", 1, time)
	await tween.finished
	
func deactivate(time: float = 0.5):
	tween = get_tree().create_tween()
	tween.set_parallel(true)

	# Animate beam and particle properties to shrink or fade out
	tween.tween_property(beam_mesh.mesh, "top_radius", 0, time)
	tween.tween_property(beam_mesh.mesh, "bottom_radius", 0, time)
	tween.tween_property(beam_particles.process_material, "scale_min", 0, time)
	tween.tween_property(end_particles.process_material, "scale_min", 0, time)
	
	# Wait for the tween to finish, then hide and stop emissions
	await tween.finished
	
	visible = false
	beam_particles.emitting = false
	end_particles.emitting = false
