extends RayCast3D

@onready var beam_mesh = $BeamMesh
@onready var end_particles = $EndParticles
@onready var beam_particles = $BeamParticles

@export var secondary_beam: bool = false
@export var transition_duration: float = 1
@export var beam_radius: float = 0.03

var tween: Tween

func _ready() -> void:
	beam_mesh.mesh = beam_mesh.mesh.duplicate()

func _process(_delta: float) -> void:
	var cast_point
	force_raycast_update()
	
	if not is_colliding(): return
	var collider = get_collider()
	if not collider.is_in_group("Player") and secondary_beam: disable_beam()
	if collider.is_in_group("Player") and secondary_beam: enable_beam()
	
	cast_point = to_local(get_collision_point())
	beam_mesh.mesh.height = cast_point.y
	beam_mesh.position.y = cast_point.y / 2
	end_particles.position.y = cast_point.y
	var particle_amount = snapped(abs(cast_point.y) * 50, 1)
	
	if particle_amount > 1:
		beam_particles.amount = particle_amount
	else: 
		beam_particles.amount = 1
		
	var material = beam_particles.process_material
	material.emission_box_extents = Vector3(
		beam_mesh.mesh.top_radius,
		abs(cast_point.y) / 2,
		beam_mesh.mesh.top_radius
	)

func activate():
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	
	enable_beam()
	
	# Animate beam and particle properties
	tween.tween_property(beam_mesh.mesh, "top_radius", beam_radius, transition_duration)
	tween.tween_property(beam_mesh.mesh, "bottom_radius", beam_radius, transition_duration)
	tween.tween_property(beam_particles.process_material, "scale_min", 1, transition_duration)
	tween.tween_property(end_particles.process_material, "scale_min", 1, transition_duration)

func deactivate():
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)

	# Animate beam and particle properties to shrink or fade out
	tween.tween_property(beam_mesh.mesh, "top_radius", 0, transition_duration)
	tween.tween_property(beam_mesh.mesh, "bottom_radius", 0, transition_duration)
	tween.tween_property(beam_particles.process_material, "scale_min", 0, transition_duration)
	tween.tween_property(end_particles.process_material, "scale_min", 0, transition_duration)

	# Wait for the tween to finish, then hide and stop emissions
	await tween.finished
	disable_beam()

func disable_beam():
	visible = false
	beam_particles.emitting = false
	end_particles.emitting = false

func enable_beam():
	visible = true
	beam_particles.emitting = true
	end_particles.emitting = true
