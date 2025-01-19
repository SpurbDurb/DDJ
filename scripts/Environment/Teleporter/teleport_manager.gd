extends Node3D

@export var teleporter_1: Node3D   
@export var teleporter_2: Node3D    

var player_1: CharacterBody3D = null  
var player_2: CharacterBody3D = null  
var can_teleport: bool = true

func _process(delta: float) -> void:
	var player_1 = teleporter_1.get("player") 
	var player_2 = teleporter_2.get("player")
	
	# um dos jogadores tem de sair da plataforma para poder vo
	if not (player_1 and player_2):
		can_teleport = true
		
	if can_teleport and player_1 and player_2: 
		teleport_player()


func teleport_player() -> void:
	can_teleport = false
	var target_position = teleporter_2.global_transform.origin

	if teleporter_1.get("player"):
		var player = teleporter_1.get("player")
		target_position = teleporter_2.global_transform.origin
		target_position.y = player.global_position.y
		player.global_position = target_position
		
	if teleporter_2.get("player"):
		var player = teleporter_2.get("player")
		target_position = teleporter_1.global_transform.origin
		target_position.y = player.global_position.y
		player.global_position = target_position
