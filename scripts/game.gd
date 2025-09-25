class_name Game extends Node

var crosshair: CompressedTexture2D = load("res://gfx/weapon/crosshair.png")

@onready var Level: Node = $Level
@onready var Players: Node = $Players
@onready var Enemies: Node = $Enemies
@onready var PlayerSpawner: MultiplayerSpawner = $PlayerSpawner
@onready var EnemySpawner: MultiplayerSpawner = $EnemySpawner
@onready var HUD: CanvasLayer = $HUD

##  Start a new game and if server replicate the level.
func start_game():
	GameState.GAME_RUNNING = true
	#  We are server
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(spawn_player)
		multiplayer.peer_disconnected.connect(remove_player)

		load_level.call_deferred(load("res://scenes/levels/level1.tscn"))

		#  Spawn already connected players
		for id in multiplayer.get_peers():
			spawn_player.call_deferred(id)
		#  Spawn the server (main) player
		spawn_player.call_deferred(1)
		#  SPAWN SOME MOBS FOR TESTING
		for n in 6:
			spawn_enemy.call_deferred("basic_mob", "SpawnLocation1", randf())
	#  We are not server
	else:
		multiplayer.peer_disconnected.connect(handle_peer_disconnect)
	#  Configure HUD and show custom mouse cursor
	HUD.show()
	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_ARROW, Vector2(32,32))

##  End the game and close the network connection.
func end_game(why: String = ""):
	GameState.GAME_RUNNING = false
	HUD.hide()
	if multiplayer.is_server():
		if multiplayer.peer_connected.is_connected(spawn_player):
			multiplayer.peer_connected.disconnect(spawn_player)
		if multiplayer.peer_disconnected.is_connected(remove_player):
			multiplayer.peer_disconnected.disconnect(remove_player)
	else:
		if multiplayer.peer_disconnected.is_connected(handle_peer_disconnect):
			multiplayer.peer_disconnected.disconnect(handle_peer_disconnect)
	#  Remove all players
	for node in Players.get_children():
		Players.remove_child(node)
		node.queue_free()
	#  Remove all enemies
	for node in Enemies.get_children():
		Enemies.remove_child(node)
		node.queue_free()
	#  Remove the level
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()
	NetworkHandler.close_connection()
	Input.set_custom_mouse_cursor(null)
	UiController.open_menu("MainUI")
	if not why.is_empty():
		Globals.alert(why)

##  Continue the game to the next stage.
func proceed_game() -> void:
	HUD.hide()
	#  Remove all enemies
	for node in Enemies.get_children():
		Enemies.remove_child(node)
		node.queue_free()
	#  Reset player list
	for node in Players.get_children():
		Players.remove_child(node)
		node.queue_free()
	#  Load the next level
	load_level.call_deferred(load("res://scenes/levels/level1.tscn"))
	#  Spawn already connected players
	for id in multiplayer.get_peers():
		spawn_player.call_deferred(id)
	#  Spawn server (main) player
	spawn_player.call_deferred(1)
	HUD.show()

##  Load a level.  Call deferred.
func load_level(scene: PackedScene) -> void:
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()
	Level.add_child(scene.instantiate())
	#  Find the spawn locations
	GameState.playerSpawners = Level.find_child("PlayerSpawners", true, false)

##  Spawn a player.  Call deferred or after the level loaded.
func spawn_player(id: int) -> void:
	if GameState.playerSpawners == null:  return
	var spawn_position: Area2D = null
	#  Look for any overlapping bodies and pick an empty spawn location
	for spawner in GameState.playerSpawners.get_children():
		if spawner is Area2D:
			if spawner.has_overlapping_bodies():
				continue
			else:
				spawn_position = spawner
				break
	if spawn_position != null:
		PlayerSpawner.spawn({ "id": id, "position": spawn_position.position })

##  Remove a player.
func remove_player(id: int) -> void:
	if not Players.has_node(str(id)): return
	Players.get_node(str(id)).queue_free()

##  Spawn a new enemy.  Call after the level loaded.
func spawn_enemy(type: String, spawn_location: String, progress: float = 0.0) -> void:
	if not multiplayer.is_server(): return
	var spawn_position: Node = Level.find_child(spawn_location, true, false)
	if spawn_position != null:
		if spawn_position is PathFollow2D:
			spawn_position.progress_ratio = progress
		EnemySpawner.spawn({ "type": type, "position": spawn_position.position })

##  Handle a player leaving the game.
func handle_peer_disconnect(id: int) -> void:
	if id == 1:
		end_game("Host has left the game!")

func _ready() -> void:
	EventBus.StartGame.connect(start_game)
	EventBus.EndGame.connect(end_game)
	
	UiController.open_menu("MainUI")

func _process(_delta: float) -> void:
	if not GameState.GAME_RUNNING: return

func _unhandled_input(event: InputEvent) -> void:
	#  Handle in-game menu only if the game is running
	if not GameState.GAME_RUNNING: return
	if event.is_action_pressed("game_menu") and Input.is_action_just_pressed("game_menu") and GameState.GAME_MENU_OPENED:
		GameState.GAME_MENU_OPENED = false
		UiController.close_all_menus()
	elif event.is_action_pressed("game_menu") and Input.is_action_just_pressed("game_menu") and not GameState.GAME_MENU_OPENED:
		GameState.GAME_MENU_OPENED = true
		UiController.open_menu("GameUI")
