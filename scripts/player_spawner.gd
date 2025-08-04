extends MultiplayerSpawner

var network_player: PackedScene = preload("res://objects/player.tscn")

func _ready() -> void:
	# Spawn players on client connect
	multiplayer.peer_connected.connect(spawn_player)

func spawn_player(id: int) -> void:
	if not multiplayer.is_server(): return

	var player: Node = network_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)
