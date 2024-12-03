extends Node
class_name Player_State

@export var exit_state : bool = false
@export_enum("White", "Black")
var character: String = "White"
@export var animation_player: AnimationPlayer
@export var player : CharacterBody3D
@export var visual : Node3D
@export var SPEED = 2.6

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
