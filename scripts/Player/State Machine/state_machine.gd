extends Node

var states : Dictionary = {}
var current_state : Player_State
@export var initial_state : Player_State

func init() -> void:
	for child in get_children():
		if child is Player_State:
			states[child.name.to_lower()] = child
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		check_change_state()

func check_change_state() -> void:
	if !current_state.exit_condition():
		return
	for state in get_children():
		if state != current_state:
			if state.enter_condition():
				change_state(state)
				return

func change_state(new_state: Player_State) -> void:
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
	print("player state:", current_state)

func force_state(state_name: String) -> void:
	if state_name not in states: return
	
	var new_state = states[state_name]
	change_state(new_state)

func get_current_state():
	return current_state
