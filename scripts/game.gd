extends Node

@onready var Level: Node = $Level
@onready var PlayerList: Node = $PlayerList
@onready var PlayerSpawner: MultiplayerSpawner = $PlayerSpawner

##  Start a game and if server replicate the level.
func start_game():
	Globals.GAME_RUNNING = true

	#  We are server
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(spawn_player)
		multiplayer.peer_disconnected.connect(remove_player)

		load_level.call_deferred(load("res://scenes/level.tscn"))

		#  Spawn already connected players
		for id in multiplayer.get_peers():
			spawn_player(id)
		#  Spawn the server player if not dedicated
		if not OS.has_feature("dedicated_server"):
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
	Globals.GAME_RUNNING = false
	for node in PlayerList.get_children():
		PlayerList.remove_child(node)
		node.queue_free()
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()
	NetworkHandler.close_connection()
	UiController.open_menu("MainUI")
	if not why.is_empty():
		Globals.alert(why)

##  Restart the game.
func restart_game() -> void:
	pass

##  Load a level
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
	if not PlayerList.has_node(str(id)): return
	PlayerList.get_node(str(id)).queue_free()

##  Handle a player leaving the game.
func handle_peer_disconnect(id: int) -> void:
	if id == 1:
		end_game("Host left the game!")

func _ready() -> void:
	EventBus.StartGame.connect(start_game)
	EventBus.EndGame.connect(end_game)

	UiController.open_menu("MainUI")
