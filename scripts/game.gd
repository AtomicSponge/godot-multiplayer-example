extends Node

@onready var Level: Node = $Level

func _ready() -> void:
	EventBus.StartGame.connect(start_game)
	EventBus.EndGame.connect(end_game)

	UiController.open_menu("MainUI")

func start_game():
	Globals.game_running = true
	if multiplayer.is_server():
		load_level.call_deferred(load("res://scenes/level.tscn"))

func end_game():
	Globals.game_running = false
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()
	NetworkHandler.close_connection()
	UiController.open_menu("MainUI")

func load_level(scene: PackedScene) -> void:
	for node in Level.get_children():
		Level.remove_child(node)
		node.queue_free()
	Level.add_child(scene.instantiate())
