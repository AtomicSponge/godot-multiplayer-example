extends Node

# For testing only

const IP_ADDRESS: String = "localhost"
const PORT: int = 42069

func start_server() -> Error:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(PORT, SteamGlobals.LOBBY_MEMBERS_MAX)
	if error: return error
	multiplayer.multiplayer_peer = peer
	EventBus.StartGame.emit()
	return OK

func start_client() -> Error:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(IP_ADDRESS, PORT)
	if error: return error
	multiplayer.multiplayer_peer = peer
	EventBus.StartGame.emit()
	return OK

func close_connection() -> void:
	multiplayer.multiplayer_peer.close()
