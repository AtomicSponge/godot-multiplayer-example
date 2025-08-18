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

var LOBBY_NAME: String = "Default Lobby Name"

var LOBBY_LIST: Array = []

var CONSOLE_BUFFER: String = ""

var game_running = false
var game_menu_opened = false

func alert(text: String) -> void:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	dialog.dialog_hide_on_ok = false # Disable default behaviour
	dialog.connect('confirmed', dialog.queue_free) # Free node on OK
	var scene_tree = Engine.get_main_loop()
	scene_tree.current_scene.add_child(dialog)
	dialog.popup_centered()

func quit_game() -> void:
	NetworkHandler.close_connection()
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _check_command_line() -> void:
	var arguments: Array = OS.get_cmdline_args()
	# There are arguments to process
	if arguments.size() > 0:
		# A Steam connection argument exists
		if arguments[0] == "+connect_lobby":
			# Lobby invite exists so try to connect to it
			if int(arguments[1]) > 0:
				NetworkHandler.start_client(int(arguments[1]))

func _ready() -> void:
	var INIT: Dictionary = Steam.steamInitEx()
	if INIT['status'] != 0:
		print("Failed to initialise Steam. " + str(INIT['verbal']) + " Shutting down...")
		quit_game()

	ONLINE = Steam.loggedOn()
	ID = Steam.getSteamID()
	NAME = Steam.getPersonaName()
	OWNED = Steam.isSubscribed()
	VAC_BANNED = Steam.isVACBanned()

	if OWNED == false:
		print("User does not own this game.")
		quit_game()

	Steam.join_requested.connect(NetworkHandler._on_lobby_join_requested)
	Steam.lobby_chat_update.connect(NetworkHandler._on_lobby_chat_update)
	Steam.lobby_created.connect(NetworkHandler._on_lobby_created)
	Steam.lobby_data_update.connect(NetworkHandler._on_lobby_data_update)
	Steam.lobby_joined.connect(NetworkHandler._on_lobby_joined)
	Steam.lobby_match_list.connect(NetworkHandler._on_lobby_match_list)
	Steam.lobby_message.connect(NetworkHandler._on_lobby_message)
	Steam.persona_state_change.connect(NetworkHandler._on_persona_change)

	_check_command_line()

func _process(_delta: float) -> void:
	Steam.run_callbacks()
