class_name Game extends Node

@onready var Level: Node = $Level
@onready var Players: Node = $Players
@onready var PlayerSpawner: MultiplayerSpawner = $PlayerSpawner
@onready var HUD: CanvasLayer = $HUD

##  Start a game and if server replicate the level.
func start_game():
	GameState.GAME_RUNNING = true
	HUD.show()

	#  We are server
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(spawn_player)
		multiplayer.peer_disconnected.connect(remove_player)

		load_level.call_deferred(load("res://scenes/levels/level1.tscn"))

		#  Spawn already connected players
		for id in multiplayer.get_peers():
			spawn_player(id)
		#  Spawn the server (main) player
		spawn_player(1)
	#  We are not server
	else:
		multiplayer.peer_disconnected.connect(handle_peer_disconnect)

##  End the game and close the network connection.
func end_game(why: String = ""):
	if multiplayer.is_server():
		if multiplayer.peer_connected.is_connected(spawn_player):
			multiplayer.peer_connected.disconnect(spawn_player)
		if multiplayer.peer_disconnected.is_connected(remove_player):
			multiplayer.peer_disconnected.disconnect(remove_player)
	else:
		if multiplayer.peer_disconnected.is_connected(handle_peer_disconnect):
			multiplayer.peer_disconnected.disconnect(handle_peer_disconnect)
	HUD.hide()
	GameState.GAME_RUNNING = false
	for node in Players.get_children():
		Players.remove_child(node)
		node.queue_free()
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()
	NetworkHandler.close_connection()
	UiController.open_menu("MainUI")
	if not why.is_empty():
		Globals.alert(why)

##  Continue the game to the next stage.
func proceed_game() -> void:
	HUD.hide()
	load_level.call_deferred(load("res://scenes/levels/level1.tscn"))
	#  Reset player list
	for node in Players.get_children():
		Players.remove_child(node)
		node.queue_free()
	#  Spawn already connected players
	for id in multiplayer.get_peers():
		spawn_player(id)
	#  Spawn server (main) player
	spawn_player(1)
	HUD.show()

##  Load a level.  Call deferred.
func load_level(scene: PackedScene) -> void:
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()
	Level.add_child(scene.instantiate())

##  Spawn a player.
func spawn_player(id: int) -> void:
	PlayerSpawner.spawn({ "id": id, "position": Vector2(randi() % 701 + 200, 150) })

##  Remove a player.
func remove_player(id: int) -> void:
	if not Players.has_node(str(id)): return
	Players.get_node(str(id)).queue_free()

##  Handle a player leaving the game.
func handle_peer_disconnect(id: int) -> void:
	if id == 1:
		end_game("Host has left the game!")

func _ready() -> void:
	EventBus.StartGame.connect(start_game)
	EventBus.EndGame.connect(end_game)

	UiController.open_menu("MainUI")

func _unhandled_input(event: InputEvent) -> void:
	#  Handle in-game menu only if the game is running
	if not GameState.GAME_RUNNING: return
	if event.is_action_pressed("game_menu") and Input.is_action_just_pressed("game_menu") and GameState.GAME_MENU_OPENED:
		GameState.GAME_MENU_OPENED = false
		UiController.close_all_menus()
	elif event.is_action_pressed("game_menu") and Input.is_action_just_pressed("game_menu") and not GameState.GAME_MENU_OPENED:
		GameState.GAME_MENU_OPENED = true
		UiController.open_menu("GameUI")
