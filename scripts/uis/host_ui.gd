extends Control

@onready var LobbyNameInput = $Panel/LobbyNameInput

func _ready() -> void:
	LobbyNameInput.text = str(SteamGlobals.NAME, "'s Lobby")
