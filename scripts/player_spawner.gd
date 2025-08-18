extends MultiplayerSpawner

var PLAYER: PackedScene = preload("res://scenes/player.tscn")

func spawn_player(id: int) -> void:
	var player: Node = PLAYER.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)

func _ready() -> void:
	if not multiplayer.is_server(): return
	multiplayer.peer_connected.connect(spawn_player)
	spawn_player(1)

func _exit_tree():
	if not multiplayer.is_server(): return
	multiplayer.peer_connected.disconnect(spawn_player)
