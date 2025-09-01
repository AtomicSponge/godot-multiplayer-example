extends Node

# Steam variables
var OWNED: bool = false			##  Does the player own the game
var ONLINE: bool = false		##  Is the player online
var ID: int = 0					##  Steam ID of the player
var NAME: String = ""			##  Steam name of the player
var VAC_BANNED: bool = false	##  Is the plyer VAC banned

# Lobby variables
var LOBBY_ID: int = 0			##  ID of the lobby
var LOBBY_MEMBERS: Array = []	##  List of lobby members
var LOBBY_MEMBERS_MAX: int = 4	##  Max allowed lobby members
var LOBBY_NAME: String = ""		##  Lobby name
var LOBBY_LIST: Array = []		##  List of players in the lobby

# Game variables
var GAME_RUNNING: bool = false		##  Is the game running
var GAME_MENU_OPENED: bool = false	##  Is the game menu opened

##  Achievements list
var achievements: Dictionary[String, bool] = {
	"Test1": false,
	"Test2": false
}

##  Quit the game
func quit_game() -> void:
	NetworkHandler.close_connection()
	get_tree().quit()

##  Show an alert
func alert(text: String) -> void:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	dialog.dialog_hide_on_ok = false # Disable default behaviour
	dialog.connect('confirmed', dialog.queue_free) # Free node on OK
	var scene_tree = Engine.get_main_loop()
	scene_tree.current_scene.add_child(dialog)
	dialog.popup_centered()

##  Set an achievement locally and on Steam
func set_achievement(this_achievement: String) -> void:
	if not achievements.has(this_achievement):
		print("This achievement does not exist locally: %s" % this_achievement)
		return
	achievements[this_achievement] = true

	if not Steam.setAchievement(this_achievement):
		print("Failed to set achievement: %s" % this_achievement)
		return
	print("Set acheivement: %s" % this_achievement)

	# Pass the value to Steam then fire it
	if not Steam.storeStats():
		print("Failed to store data on Steam, should be stored locally")
		return
	print("Data successfully sent to Steam")

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
	#  Configure Steam
	var INIT: Dictionary = Steam.steamInitEx(480, true)
	if INIT['status'] != 0:
		OS.alert("Failed to initialise Steam. " + str(INIT['verbal']) + " Shutting down...")
		quit_game()
		return

	Steam.initRelayNetworkAccess()

	ONLINE = Steam.loggedOn()
	ID = Steam.getSteamID()
	NAME = Steam.getPersonaName()
	OWNED = Steam.isSubscribed()
	VAC_BANNED = Steam.isVACBanned()

	if OWNED == false:
		OS.alert("User does not own this game.")
		quit_game()
		return

	Steam.join_requested.connect(NetworkHandler._on_lobby_join_requested)
	Steam.lobby_chat_update.connect(NetworkHandler._on_lobby_chat_update)
	Steam.lobby_created.connect(NetworkHandler._on_lobby_created)
	Steam.lobby_data_update.connect(NetworkHandler._on_lobby_data_update)
	Steam.lobby_joined.connect(NetworkHandler._on_lobby_joined)
	Steam.lobby_match_list.connect(NetworkHandler._on_lobby_match_list)
	Steam.lobby_message.connect(NetworkHandler._on_lobby_message)
	Steam.persona_state_change.connect(NetworkHandler._on_persona_change)

	_check_command_line()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if Globals.GAME_RUNNING:
			EventBus.EndGame.emit()
		get_tree().quit()
