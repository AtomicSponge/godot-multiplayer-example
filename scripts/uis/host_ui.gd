extends Control

@onready var LobbyNameInput = $Panel/LobbyNameInput

func _ready() -> void:
	LobbyNameInput.text = str(SteamGlobals.NAME, "'s Lobby")

func _on_back_button_pressed() -> void:
	UiController.close_menu()
