extends Node

# For testing only
const IP_ADDRESS: String = "localhost"
const PORT: int = 42069

#var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()

func start_server(this_name: String) -> Error:
	Globals.LOBBY_NAME = this_name
	#var error: Error = peer.create_server(PORT, Globals.LOBBY_MEMBERS_MAX)
	var error: Error = peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC, Globals.LOBBY_MEMBERS_MAX)
	if error: return error
	multiplayer.multiplayer_peer = peer
	EventBus.StartGame.emit()
	return OK

func start_client(this_lobby_id: int) -> Error:
	Globals.LOBBY_MEMBERS.clear()
	#var error: Error = peer.create_client(IP_ADDRESS, PORT)
	var error: Error = peer.connect_lobby(this_lobby_id)
	if error: return error
	multiplayer.multiplayer_peer = peer
	EventBus.StartGame.emit()
	return OK

# Rename later
func close_connection() -> void:
	# If in a lobby, leave it
	if Globals.LOBBY_ID != 0:
		# Send leave request to Steam
		Steam.leaveLobby(Globals.LOBBY_ID)
		multiplayer.multiplayer_peer.close()

		# Wipe the Steam lobby ID then display the default lobby ID and player list title
		Globals.LOBBY_ID = 0

		# Close session with all users
		for this_member in Globals.LOBBY_MEMBERS:
			# Make sure this isn't your Steam ID
			if this_member['steam_id'] != Globals.ID:
				# Close the P2P session using the Networking class
				Steam.closeP2PSessionWithUser(this_member['steam_id'])
		# Clear the local lobby list
		Globals.LOBBY_MEMBERS.clear()

func __close_connection() -> void:
	multiplayer.multiplayer_peer.close()

func is_network_connected() -> bool:
	return multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED

func search_for_lobbies(search_string: String = "") -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_DEFAULT)
	if not search_string.is_empty():
		Steam.addRequestLobbyListStringFilter("name", search_string, Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()
	await get_tree().create_timer(3).timeout
	if Globals.LOBBY_LIST.is_empty():
		await get_tree().create_timer(2).timeout

func _on_lobby_join_requested(this_lobby_id: int, friend_id: int) -> void:
	var _owner_name: String = Steam.getFriendPersonaName(friend_id)
	UiController.close_all_menus()
	start_client(this_lobby_id)

func _on_lobby_chat_update(_this_lobby_id: int, change_id: int, _making_change_id: int, chat_state: int) -> void:
	# Get the user who has made the lobby change
	var changer_name: String = Steam.getFriendPersonaName(change_id)

	# If a player has joined the lobby
	if chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
		Console.add_text("%s has joined the lobby." % changer_name)
	# Else if a player has left the lobby
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
		Console.add_text("%s has left the lobby." % changer_name)
	# Else if a player has been kicked
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_KICKED:
		Console.add_text("%s has been kicked from the lobby." % changer_name)
	# Else if a player has been banned
	elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_BANNED:
		Console.add_text("%s has been banned from the lobby." % changer_name)
	# Else there was some unknown change
	else:
		Console.add_text("%s did... something." % changer_name)

	# Update the lobby now that a change has occurred
	_get_lobby_members()

func _on_lobby_created(connected: int, this_lobby_id: int) -> void:
	if connected == 1:
		# Set the lobby ID
		Globals.LOBBY_ID = this_lobby_id
		# Set this lobby as joinable, just in case, though this should be done by default
		Steam.setLobbyJoinable(Globals.LOBBY_ID, true)
		# Set some lobby data
		Steam.setLobbyData(Globals.LOBBY_ID, "name", Globals.LOBBY_NAME)
		# Allow P2P connections to fallback to being relayed through Steam if needed
		var _set_relay: bool = Steam.allowP2PPacketRelay(true)

func _on_lobby_data_update(_success: int, _this_lobby_id: int, _this_member_id: int) -> void:
	pass

func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
	# If joining was successful
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		# Set this lobby ID as your lobby ID
		Globals.LOBBY_ID = this_lobby_id

		# Get the lobby members
		_get_lobby_members()

		# Make the initial handshake
		# send_p2p_packet(0, {"message": "handshake", "from": ID})
		# https://godotsteam.com/tutorials/networking/#__tabbed_3_2

	# Else it failed for some reason
	else:
		# Get the failure reason
		var fail_reason: String

		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST: fail_reason = "This lobby no longer exists."
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED: fail_reason = "You don't have permission to join this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL: fail_reason = "The lobby is now full."
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR: fail_reason = "Uh... something unexpected happened!"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED: fail_reason = "You are banned from this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED: fail_reason = "You cannot join due to having a limited account."
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED: fail_reason = "This lobby is locked or disabled."
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN: fail_reason = "This lobby is community locked."
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU: fail_reason = "A user in the lobby has blocked you from joining."
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER: fail_reason = "A user you have blocked is in the lobby."

		Globals.alert("Failed to join this lobby: %s" % fail_reason)

func _on_lobby_match_list(these_lobbies: Array) -> void:
	Globals.LOBBY_LIST = these_lobbies

func _on_lobby_message() -> void:
	pass

func _on_persona_change(this_steam_id: int, _flag: int) -> void:
	# Make sure you're in a lobby and this user is valid or Steam might spam your console log
	if Globals.LOBBY_ID > 0:
		print("A user (%s) had information change, update the lobby list" % this_steam_id)
		# Update the player list
		_get_lobby_members()

func _get_lobby_members() -> void:
	# Clear your previous lobby list
	Globals.LOBBY_MEMBERS.clear()
	# Get the number of members from this lobby from Steam
	var num_of_members: int = Steam.getNumLobbyMembers(Globals.LOBBY_ID)
	# Get the data of these players from Steam
	for this_member in range(0, num_of_members):
		# Get the member's Steam ID
		var member_steam_id: int = Steam.getLobbyMemberByIndex(Globals.LOBBY_ID, this_member)
		# Get the member's Steam name
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		# Add them to the list
		Globals.LOBBY_MEMBERS.append({"steam_id": member_steam_id, "steam_name": member_steam_name})
