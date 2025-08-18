extends Node2D

@onready var PlayerList: Node = $PlayerList

var PLAYER: PackedScene = preload("res://scenes/player.tscn")

func _spawn_player(id: int) -> void:
	var player: Node = PLAYER.instantiate()
	player.name = str(id)
	player.global_position = Vector2(randi() % 401 + 400, 350)
	PlayerList.call_deferred("add_child", player)

func _remove_player(id: int) -> void:
	if not PlayerList.has_node(str(id)): return
	PlayerList.get_node(str(id)).queue_free()

func _ready() -> void:
	if not multiplayer.is_server(): return
	multiplayer.peer_connected.connect(_spawn_player)
	multiplayer.peer_disconnected.connect(_remove_player)

	for id in multiplayer.get_peers():
		_spawn_player(id)

	if not OS.has_feature("dedicated_server"):
		_spawn_player(1)
