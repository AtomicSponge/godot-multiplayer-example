extends Control

@onready var LobbyScroller = $Panel/LobbyScroller
@onready var LobbyList = $Panel/LobbyScroller/LobbyList
@onready var SearchingLabel = $Panel/LobbyScroller/LobbyList/SearchingLabel
@onready var SearchInput = $Panel/SearchInput

func _build_lobby_list(search_string: String = "") -> void:
	for node in LobbyList.get_children():
		if node is Button:
			LobbyList.remove_child(node)
			node.queue_free()

	SearchingLabel.show()
	await SteamGlobals.search_for_lobbies(search_string)
	SearchingLabel.hide()

	for lobby in SteamGlobals.LOBBY_LIST:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		var lobby_num_members: int = Steam.getNumLobbyMembers(lobby)

		var lobby_button: Button = Button.new()
		lobby_button.set_text("Lobby %s: %s - %s Player(s)" % [lobby, lobby_name, lobby_num_members])
		lobby_button.set_size(Vector2(LobbyScroller.size.x, 50))
		lobby_button.set_name("lobby_%s" % lobby)
		lobby_button.connect("pressed", Callable(SteamGlobals, "join_lobby").bind(lobby))

		LobbyList.add_child(lobby_button)

func _ready() -> void:
	await _build_lobby_list()

func _on_search_button_pressed() -> void:
	await _build_lobby_list(SearchInput.text)

func _on_back_button_pressed() -> void:
	UiController.close_menu()
