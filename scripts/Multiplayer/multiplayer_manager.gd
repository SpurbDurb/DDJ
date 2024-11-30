extends Node

var spawn
var id_list := []

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var player_mp_scene = preload("res://scenes/Player/player_mp.tscn")

func host():
	print("host")
	_add_player(1)
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)

func join():
	print("join")
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer
	
	SceneManager.switch_scene("res://scenes/Levels/multiplayer_proto_level.tscn")


func _add_player(id: int):
	print("Player %s join the game :)" % id)
	id_list.append(id)
	
	if id_list.size() == 2:
		SceneManager.switch_scene("res://scenes/Levels/multiplayer_proto_level.tscn")
		spawn_players()

func spawn_players():
	call_deferred("_deferred_spawn_scene")

func _deferred_spawn_scene():
	spawn = get_tree().get_current_scene().get_node("Spawn")
	for id in id_list:
		var player_mp = player_mp_scene.instantiate()
		player_mp.player_id = id
		player_mp.name = str(id)
		spawn.add_child(player_mp, true)

func _remove_player(id: int):
	print("Player %s left the game :(" % id)
	id_list.erase(id)
