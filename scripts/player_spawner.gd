extends MultiplayerSpawner

var PLAYER: PackedScene = preload("res://scenes/players/player.tscn")

func _make_player(data: Dictionary) -> Node:
	var player: Node = PLAYER.instantiate()
	player.name = str(data.id)
	player.position = data.position
	return player

func _enter_tree() -> void:
	set_spawn_function(_make_player)
