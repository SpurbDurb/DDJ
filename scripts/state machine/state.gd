extends Node
class_name State

@export var exit_state : bool = false

func enter() -> void:
	pass

func exit():
	pass

func update(_deta:float):
	pass

func exit_condition() -> bool:
	return exit_state

func enter_condition() -> bool:
	return true
