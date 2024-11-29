extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

func host():
	print("host")
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_connect_player)
	multiplayer.peer_disconnected.connect(_remove_player)

func join():
	print("join")
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer


func _connect_player(id: int):
	print("Player %s join the game :)" % id)

func _remove_player(id: int):
	print("Player %s left the game :(" % id)
