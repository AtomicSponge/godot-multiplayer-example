extends Node

## TESTING VARIABLES
var IP_ADDRESS: String = "127.0.0.1"
var PORT: int = 42069
var USE_ENET: bool = true

##  Start the multiplayer server and trigger a new game
func start_server(this_name: String) -> void:
	if USE_ENET:
		var peer = ENetMultiplayerPeer.new()
		peer.create_server(PORT, 4)
		multiplayer.multiplayer_peer = peer
		EventBus.StartGame.emit()
	else:
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
	multiplayer.multiplayer_peer.close()
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

##
func _on_lobby_join_requested(this_lobby_id: int, friend_id: int) -> void:
	var _owner_name: String = Steam.getFriendPersonaName(friend_id)
	UiController.close_all_menus()
	start_client(this_lobby_id)

##
func _on_lobby_chat_update(_this_lobby_id: int, change_id: int, _making_change_id: int, chat_state: int) -> void:
	# Get the user who has made the lobby change
	var changer_name: String = Steam.getFriendPersonaName(change_id)
	# If a player has joined the lobby
	#if chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
		#Console.add_text("%s has joined the lobby." % changer_name)
	# Else if a player has left the lobby
	#elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
		#Console.add_text("%s has left the lobby." % changer_name)
	# Else if a player has been kicked
	#elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_KICKED:
		#Console.add_text("%s has been kicked from the lobby." % changer_name)
	# Else if a player has been banned
	#elif chat_state == Steam.CHAT_MEMBER_STATE_CHANGE_BANNED:
		#Console.add_text("%s has been banned from the lobby." % changer_name)
	# Else there was some unknown change
	#else:
		#Console.add_text("%s did... something." % changer_name)

	# Update the lobby now that a change has occurred
	_get_lobby_members()

##
func _on_lobby_created(connected: int, this_lobby_id: int) -> void:
	match connected:
		Steam.Result.RESULT_OK:
			Globals.LOBBY_ID = this_lobby_id
			# Set this lobby as joinable, just in case, though this should be done by default
			Steam.setLobbyJoinable(Globals.LOBBY_ID, true)
			# Set some lobby data
			Steam.setLobbyData(Globals.LOBBY_ID, "name", Globals.LOBBY_NAME)
			var peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
			peer.host_with_lobby(this_lobby_id)
			multiplayer.multiplayer_peer = peer
			# Allow P2P connections to fallback to being relayed through Steam if needed
			var _set_relay: bool = Steam.allowP2PPacketRelay(false)
			EventBus.StartGame.emit()
		_:
			pass
		#	 There was a problem, do something about it

##
func _on_lobby_data_update(_success: int, _this_lobby_id: int, _this_member_id: int) -> void:
	pass

##
func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
	#  If hosting ignore
	if Steam.getLobbyOwner(this_lobby_id) == Steam.getSteamID():
		return

	# If joining was successful
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		# Set this lobby ID as your lobby ID
		Globals.LOBBY_ID = this_lobby_id
		var peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
		peer.connect_to_lobby(this_lobby_id)
		multiplayer.multiplayer_peer = peer
		# Get the lobby members
		_get_lobby_members()
		EventBus.StartGame.emit()
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
		UiController.open_menu("JoinUI")
		Globals.alert("Failed to join this lobby: %s" % fail_reason)

##
func _on_lobby_match_list(these_lobbies: Array) -> void:
	Globals.LOBBY_LIST = these_lobbies

##
func _on_lobby_message(lobby_id: int, user: int, message: String, _chat_type: int) -> void:
	if lobby_id != Globals.LOBBY_ID:
		return
	var sender_name = ""
	for member in Globals.LOBBY_MEMBERS:
		if member.steam_id == user:
			sender_name = member.steam_name
	#Console.add_text(sender_name + ":  " + message)

##
func _on_persona_change(this_steam_id: int, _flags: int) -> void:
	# Make sure you're in a lobby
	if Globals.LOBBY_ID > 0:
		# Update the player list
		_get_lobby_members()
		# If you changed your name, update the display
		if this_steam_id == Globals.ID:
			var new_name = Steam.getPersonaName()
			Globals.NAME = new_name
			EventBus.UpdatePlayerName.emit()

##
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
		Globals.LOBBY_MEMBERS.append({ "steam_id": member_steam_id, "steam_name": member_steam_name })
