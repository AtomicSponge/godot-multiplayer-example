extends CanvasLayer

@onready var LobbyNameInput = $Panel/LobbyNameInput
@onready var PublicCheckBox = $Panel/PublicCheckBox
@onready var InviteOnlyCheckBox = $Panel/InviteOnlyCheckBox

func _ready() -> void:
	LobbyNameInput.text = str(Globals.NAME, "'s Lobby")

func _on_back_button_pressed() -> void:
	UiController.close_menu()

func _on_host_button_pressed() -> void:
	UiController.close_all_menus()
	NetworkHandler.start_server(LobbyNameInput.text)
