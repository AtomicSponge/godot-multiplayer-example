extends Node

# Steam variables
var OWNED: bool = false
var ONLINE: bool = false
var STEAM_ID: int = 0
var STEAM_NAME: String = ""
var VAC_BANNED: bool = false

# Lobby variables
var DATA
var LOBBY_ID = 0
var LOBBY_MEMBERS = []
var LOBBY_INVITE_ARG = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var INIT = Steam.steamInitEx()
	if INIT['status'] != 0:
		print("Failed to initialise Steam. " + str(INIT['verbal']) + " Shutting down...")
		get_tree().quit()

	ONLINE = Steam.loggedOn()
	STEAM_ID = Steam.getSteamID()
	STEAM_NAME = Steam.getPersonaName()
	OWNED = Steam.isSubscribed()
	VAC_BANNED = Steam.isVACBanned()

	if OWNED == false:
		print("User does not own this game.")
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Steam.run_callbacks()
