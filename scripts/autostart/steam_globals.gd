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

func create_lobby() -> void:
	if LOBBY_ID == 0:
		Steam.createLobby(Steam.LOBBY_TYPE_FRIENDS_ONLY, LOBBY_MEMBERS_MAX)

func _ready() -> void:
	var INIT = Steam.steamInitEx()
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

	_check_command_line()

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
