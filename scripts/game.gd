extends Node

@onready var Level: Node = $Level

@rpc
func kick_players():
	end_game()

func start_game():
	Globals.game_running = true
	if multiplayer.is_server():
		load_level.call_deferred(load("res://scenes/level.tscn"))

func end_game():
	#if multiplayer.is_server():
		#kick_players().rpc()
	Globals.game_running = false
	_unload_level.call_deferred()
	NetworkHandler.close_connection()
	UiController.open_menu("MainUI")

func load_level(scene: PackedScene) -> void:
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()
	Level.add_child(scene.instantiate())

func _unload_level() -> void:
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()

func _notification(what):
	if Globals.game_running and what == NOTIFICATION_WM_CLOSE_REQUEST:
		NetworkHandler.close_connection()

func _ready() -> void:
	EventBus.StartGame.connect(start_game)
	EventBus.EndGame.connect(end_game)

	UiController.open_menu("MainUI")
