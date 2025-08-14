extends Node

# Steam variables
var OWNED: bool = false
var ONLINE: bool = false
var ID: int = 0
var NAME: String = ""
var VAC_BANNED: bool = false

# Lobby variables
var DATA
var LOBBY_ID: int = 0
var LOBBY_MEMBERS: Array = []
var LOBBY_MEMBERS_MAX: int = 8
var LOBBY_INVITE_ARG: bool = false

var LOBBY_NAME: String = "Test Lobby Name"

var LOBBY_LIST: Array = []

func create_lobby() -> void:
	if LOBBY_ID == 0:
		Steam.createLobby(Steam.LOBBY_TYPE_FRIENDS_ONLY, LOBBY_MEMBERS_MAX)

func _ready() -> void:
	var INIT: Dictionary = Steam.steamInitEx()
	if INIT['status'] != 0:
		print("Failed to initialise Steam. " + str(INIT['verbal']) + " Shutting down...")
		Globals.quit_game()

	ONLINE = Steam.loggedOn()
	ID = Steam.getSteamID()
	NAME = Steam.getPersonaName()
	OWNED = Steam.isSubscribed()
	VAC_BANNED = Steam.isVACBanned()

	if OWNED == false:
		print("User does not own this game.")
		Globals.quit_game()

	Steam.join_requested.connect(_on_lobby_join_requested)
	Steam.lobby_chat_update.connect(_on_lobby_chat_update)
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_data_update.connect(_on_lobby_data_update)
	Steam.lobby_invite.connect(_on_lobby_invite)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_message.connect(_on_lobby_message)
	Steam.persona_state_change.connect(_on_persona_change)

	_check_command_line()

func _on_lobby_join_requested() -> void:
	pass

func _on_lobby_chat_update() -> void:
	pass

func _on_lobby_created(connected: int, this_lobby_id: int) -> void:
	if connected == 1:
		# Set the lobby ID
		LOBBY_ID = this_lobby_id

		# Set this lobby as joinable, just in case, though this should be done by default
		Steam.setLobbyJoinable(LOBBY_ID, true)

		# Set some lobby data
		Steam.setLobbyData(LOBBY_ID, "name", LOBBY_NAME)
		Steam.setLobbyData(LOBBY_ID, "mode", "GodotSteam test")

		# Allow P2P connections to fallback to being relayed through Steam if needed
		var _set_relay: bool = Steam.allowP2PPacketRelay(true)

func _on_lobby_data_update() -> void:
	pass

func _on_lobby_invite() -> void:
	pass

func _on_lobby_joined() -> void:
	pass

func _on_lobby_match_list(these_lobbies: Array) -> void:
	LOBBY_LIST = these_lobbies

func _on_lobby_message() -> void:
	pass

func _on_persona_change(this_steam_id: int, _flag: int) -> void:
	# Make sure you're in a lobby and this user is valid or Steam might spam your console log
	if LOBBY_ID > 0:
		print("A user (%s) had information change, update the lobby list" % this_steam_id)
		# Update the player list
		#get_lobby_members()

func _process(_delta: float) -> void:
	Steam.run_callbacks()

func _check_command_line() -> void:
	var arguments: Array = OS.get_cmdline_args()
	# There are arguments to process
	if arguments.size() > 0:
		# A Steam connection argument exists
		if arguments[0] == "+connect_lobby":
			# Lobby invite exists so try to connect to it
			if int(arguments[1]) > 0:
				# At this point, you'll probably want to change scenes
				# Something like a loading into lobby screen
				print("Command line lobby ID: %s" % arguments[1])
				#join_lobby(int(arguments[1]))
