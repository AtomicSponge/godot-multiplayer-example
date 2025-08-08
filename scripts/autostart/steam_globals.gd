extends Node

# Steam variables
var OWNED: bool = false
var ONLINE: bool = false
var ID: int = 0
var NAME: String = ""
var VAC_BANNED: bool = false

# Lobby variables
var DATA
var LOBBY_ID = 0
var LOBBY_MEMBERS = []
var LOBBY_INVITE_ARG = false

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

func _process(_delta: float) -> void:
	Steam.run_callbacks()
