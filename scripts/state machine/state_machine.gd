extends Node
class_name state_machine

var states : Dictionary = {}
var current_state : State
@export var initial_state : State

func init() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func change_state(source_state: State, new_state_name: String):
	# Checkar
	if source_state != current_state:
		print(source_state)
		print(current_state)
		print("Invalid source_state")
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print ("New state is empty")
		return
	
	# Funcionalidade
	if current_state:
		current_state.Exit()
	new_state.Enter()
	current_state = new_state

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
