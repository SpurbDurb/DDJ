extends Node3D

@onready var sky_material = $WorldEnvironment.environment.sky.sky_material

# Start colors
@onready var start_color_top = sky_material.get_shader_parameter("color_top")
@onready var start_color_horizon = sky_material.get_shader_parameter("color_horizon")
@onready var start_color_bottom = sky_material.get_shader_parameter("color_bottom")

# End colors
var end_color_top = Color("710069")
var end_color_horizon = Color("c2008c")
var end_color_bottom = Color("ff82f4")

# Duration of the transition in seconds
var duration = 60.0
var elapsed_time = 0.0
var forward = true # Direction flag (true = forward, false = backward)

func _process(delta):
	# Update elapsed time based on the direction
	if forward:
		elapsed_time += delta
	else:
		elapsed_time -= delta

	# Clamp elapsed time between 0 and duration
	elapsed_time = clamp(elapsed_time, 0, duration)
	
	# Calculate the interpolation factor
	var t = elapsed_time / duration
	
	# Interpolate the colors
	var current_color_top = start_color_top.lerp(end_color_top, t)
	var current_color_horizon = start_color_horizon.lerp(end_color_horizon, t)
	var current_color_bottom = start_color_bottom.lerp(end_color_bottom, t)

	# Update the shader parameters
	sky_material.set_shader_parameter("color_top", current_color_top)
	sky_material.set_shader_parameter("color_horizon", current_color_horizon)
	sky_material.set_shader_parameter("color_bottom", current_color_bottom)

	# Reverse direction at the ends
	if elapsed_time == duration and forward:
		forward = false # Switch to reverse
	elif elapsed_time == 0 and not forward:
		forward = true # Switch to forward
