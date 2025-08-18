extends MultiplayerSpawner

var PLAYER: PackedScene = preload("res://scenes/player.tscn")

func _make_player(data:Dictionary) -> Node:
	var player: Node = PLAYER.instantiate()
	player.name = str(data.id)
	player.global_position = Vector2(randi() % 201 + 700, 350)
	return player

func _ready() -> void:
	set_spawn_function(_make_player)
