extends Node

## TESTING VARIABLES
var IP_ADDRESS: String = "127.0.0.1"
var PORT: int = 42069
var USE_ENET: bool = false

##  Start the multiplayer server and trigger a new game
func start_server(this_name: String) -> void:
	if USE_ENET:
		var peer = ENetMultiplayerPeer.new()
		peer.create_server(PORT, 4)
		multiplayer.multiplayer_peer = peer
		EventBus.StartGame.emit()
	else:
		Globals.LOBBY_MEMBERS.clear()
		Globals.LOBBY_NAME = this_name
		Steam.createLobby(Steam.LobbyType.LOBBY_TYPE_PUBLIC, Globals.LOBBY_MEMBERS_MAX)

##  Start the multiplayer client and trigger a new game
func start_client(this_lobby_id: int) -> void:
	if USE_ENET:
		var peer = ENetMultiplayerPeer.new()
		peer.create_client(IP_ADDRESS, PORT)
		multiplayer.multiplayer_peer = peer
		EventBus.StartGame.emit()
	else:
		Globals.LOBBY_MEMBERS.clear()
		Steam.joinLobby(this_lobby_id)

##  Close network connection
func close_connection() -> void:
	# If in a lobby, leave it
	if Globals.LOBBY_ID != 0:
		# Send leave request to Steam
		Steam.leaveLobby(Globals.LOBBY_ID)

		# Wipe the Steam lobby ID
		Globals.LOBBY_ID = 0

		# Close session with all users
		for this_member in Globals.LOBBY_MEMBERS:
			# Make sure this isn't your Steam ID
			if this_member['steam_id'] != Globals.ID:
				# Close the P2P session using the Networking class
				Steam.closeP2PSessionWithUser(this_member['steam_id'])
		# Clear the local lobby list
		Globals.LOBBY_MEMBERS.clear()
	multiplayer.multiplayer_peer.close()

##  Check if the network connection is active
func is_network_connected() -> bool:
	return multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED

##  Search for lobbies.  Provide an optional string to search for an exact match.
func search_for_lobbies(search_string: String = "") -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_FAR)
	if not search_string.is_empty():
		Steam.addRequestLobbyListStringFilter("name", search_string, Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()
	await get_tree().create_timer(3).timeout
	if Globals.LOBBY_LIST.is_empty():
		await get_tree().create_timer(2).timeout
