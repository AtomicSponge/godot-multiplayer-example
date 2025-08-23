extends Node

@onready var Level: Node = $Level
@onready var PlayerList: Node = $PlayerList
@onready var PlayerSpawner: MultiplayerSpawner = $PlayerSpawner

##  Start a game and if server replicate the level
func start_game():
	Globals.GAME_RUNNING = true
	if multiplayer.is_server():
		load_level.call_deferred(load("res://scenes/level.tscn"))

	if not multiplayer.is_server(): return
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.server_disconnected.connect(remove_player)

	for id in multiplayer.get_peers():
		spawn_player(id)

	if not OS.has_feature("dedicated_server"):
		spawn_player(1)

##  End the game and close the network connection
func end_game(why: String = ""):
	if multiplayer.is_server():
		disconnect_all_players.rpc()
		remove_player(1)
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

##  Load a level
func load_level(scene: PackedScene) -> void:
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()
	Level.add_child(scene.instantiate())

##  Spawn a player
func spawn_player(id: int) -> void:
	PlayerSpawner.spawn({ "id": id, "position": Vector2(randi() % 701 + 200, 350) })

##  Remove a player
func remove_player(id: int) -> void:
	if not PlayerList.has_node(str(id)): return
	PlayerList.get_node(str(id)).queue_free()

@rpc("authority", "call_remote", "reliable")
func disconnect_all_players() -> void:
	EventBus.EndGame.emit("Server disconnected from the game!")

func _ready() -> void:
	EventBus.StartGame.connect(start_game)
	EventBus.EndGame.connect(end_game)

	UiController.open_menu("MainUI")
