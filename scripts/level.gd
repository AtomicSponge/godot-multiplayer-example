extends Node2D

@onready var PlayerList: Node = $PlayerList
@onready var PlayerSpawner: MultiplayerSpawner = $PlayerSpawner

var PLAYER: PackedScene = preload("res://scenes/player.tscn")

func _set_player_position(player: Node) -> void:
	if player.is_inside_tree():
		player.global_position = Vector2(randi() % 401 + 400, 350)

func _make_player(data:Dictionary) -> Node:
	var player: Node = PLAYER.instantiate()
	player.name = str(data.id)
	call_deferred("_set_player_position", player)
	return player

func _spawn_player(id: int) -> void:
	PlayerSpawner.spawn({ "id": id })

func _remove_player(id: int) -> void:
	if not PlayerList.has_node(str(id)): return
	PlayerList.get_node(str(id)).queue_free()

func _ready() -> void:
	PlayerSpawner.set_spawn_function(_make_player)
	if not multiplayer.is_server(): return
	multiplayer.peer_connected.connect(_spawn_player)
	multiplayer.peer_disconnected.connect(_remove_player)

	for id in multiplayer.get_peers():
		_spawn_player(id)

	if not OS.has_feature("dedicated_server"):
		_spawn_player(1)
