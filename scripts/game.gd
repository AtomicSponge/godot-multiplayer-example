extends Node

@onready var Level: Node = $Level

func _ready() -> void:
	EventBus.StartGame.connect(start_game)

	UiController.open_menu("MainUI")

func start_game():
	if multiplayer.is_server():
		change_level.call_deferred(load("res://scenes/level.tscn"))

func change_level(scene: PackedScene) -> void:
	var level = Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	level.add_child(scene.instantiate())
