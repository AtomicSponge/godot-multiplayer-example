extends CanvasLayer

@onready var LobbyScroller: ScrollContainer = $Panel/LobbyScroller
@onready var LobbyList: HFlowContainer = $Panel/LobbyScroller/LobbyList
@onready var SearchingLabel: Label = $Panel/LobbyScroller/LobbyList/SearchingLabel
@onready var SearchInput: LineEdit = $Panel/SearchInput

##  Join a lobby by ID
func join_lobby(id: int) -> void:
	UiController.close_all_menus()
	var error = NetworkHandler.start_client(id)
	if error:
		UiController.open_menu("JoinUI")

##  Build the lobby list.  Takes an optional string to do an exact search.
func build_lobby_list(search_string: String = "") -> void:
	for node in LobbyList.get_children():
		if node is Button:
			LobbyList.remove_child(node)
			node.queue_free()

	SearchingLabel.show()
	await NetworkHandler.search_for_lobbies(search_string)
	if Globals.LOBBY_LIST.is_empty():
		SearchingLabel.set_text("No lobbies found!")
	else:
		SearchingLabel.hide()

	for lobby in Globals.LOBBY_LIST:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		var lobby_num_members: int = Steam.getNumLobbyMembers(lobby)

		var lobby_button: Button = Button.new()
		lobby_button.set_text("Lobby %s: %s - %s Player(s)" % [lobby, lobby_name, lobby_num_members])
		lobby_button.set_size(Vector2(LobbyScroller.size.x, 50))
		lobby_button.set_name("lobby_%s" % lobby)
		lobby_button.connect("pressed", join_lobby.bind(lobby))

		LobbyList.add_child(lobby_button)

func _ready() -> void:
	await build_lobby_list()

func _on_search_button_pressed() -> void:
	await build_lobby_list(SearchInput.text)

func _on_back_button_pressed() -> void:
	UiController.close_menu()
