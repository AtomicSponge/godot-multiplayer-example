extends CanvasLayer

@onready var LobbyNameInput: LineEdit = $Panel/LobbyNameInput
@onready var PublicCheckBox: CheckBox = $Panel/PublicCheckBox
@onready var InviteOnlyCheckBox: CheckBox = $Panel/InviteOnlyCheckBox

func _ready() -> void:
	LobbyNameInput.text = str(Globals.NAME, "'s Lobby")

func _on_back_button_pressed() -> void:
	UiController.close_menu()

func _on_host_button_pressed() -> void:
	UiController.close_all_menus()
	NetworkHandler.start_server(LobbyNameInput.text)
