extends Node

@onready var Level: Node = $Level

##  Start a game and if server replicate the level
func start_game():
	Globals.GAME_RUNNING = true
	if multiplayer.is_server():
		load_level.call_deferred(load("res://scenes/level.tscn"))

##  End the game and close the network connection
func end_game(why: String = ""):
	Globals.GAME_RUNNING = false
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

func _ready() -> void:
	EventBus.StartGame.connect(start_game)
	EventBus.EndGame.connect(end_game)

	UiController.open_menu("MainUI")
