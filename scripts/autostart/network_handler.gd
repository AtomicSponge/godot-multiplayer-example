extends Node

const SERVER_ID: int = 1
const IP_ADDRESS: String = "localhost"
const PORT: int = 42069
const MAX_PLAYERS = 8

var peer: ENetMultiplayerPeer

func start_server() -> Error:
	peer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(PORT, MAX_PLAYERS)
	if error: return error
	multiplayer.multiplayer_peer = peer
	return OK

func start_client() -> Error:
	peer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(IP_ADDRESS, PORT)
	if error: return error
	multiplayer.multiplayer_peer = peer
	return OK

func close_connection() -> void:
	multiplayer.multiplayer_peer = null
