extends Node

const SERVER_ID: int = 1
const IP_ADDRESS: String = "localhost"
const PORT: int = 42069
const MAX_PLAYERS = 8

#var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()

func start_server() -> Error:
	#var error: Error = peer.create_server(PORT, MAX_PLAYERS)
	var error: Error = peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC, SteamGlobals.LOBBY_MEMBERS_MAX)
	if error: return error
	multiplayer.multiplayer_peer = peer
	return OK

func start_client() -> Error:
	#var error: Error = peer.create_client(IP_ADDRESS, PORT)
	var error: Error = peer.connect_lobby(SteamGlobals.LOBBY_ID)
	if error: return error
	multiplayer.multiplayer_peer = peer
	return OK

func close_connection() -> void:
	multiplayer.multiplayer_peer = null
