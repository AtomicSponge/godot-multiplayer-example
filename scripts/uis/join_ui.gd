extends Control

@onready var LobbyList = $Panel/LobbyScroller/LobbyList
@onready var LobbyScroller = $Panel/LobbyScroller

func _ready() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_DEFAULT)
	#Steam.addRequestLobbyListStringFilter()
	Steam.requestLobbyList()

	for lobby in SteamGlobals.LOBBY_LIST:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		var lobby_mode: String = Steam.getLobbyData(lobby, "mode")
		var lobby_num_members: int = Steam.getNumLobbyMembers(lobby)

		var lobby_button: Button = Button.new()
		lobby_button.set_text("Lobby %s: %s [%s] - %s Player(s)" % [lobby, lobby_name, lobby_mode, lobby_num_members])
		lobby_button.set_size(Vector2(LobbyScroller.size.x, 50))
		lobby_button.set_name("lobby_%s" % lobby)
		#lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))

		LobbyList.add_child(lobby_button)

func _on_back_button_pressed() -> void:
	UiController.close_menu()
