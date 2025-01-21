extends Area3D

@onready var white_cp: Node3D = $white_cp
@onready var black_cp: Node3D = $black_cp

var players_entered: Array = []

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and body not in players_entered:
		players_entered.append(body)
	if players_entered.size() == 2:
		update_spawns()

func update_spawns() -> void:
	if players_entered.size() == 2:
		players_entered[0].spawn_position = black_cp.global_position
		players_entered[1].spawn_position = white_cp.global_position
	queue_free()
