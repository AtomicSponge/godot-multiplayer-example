extends Node2D

@onready var PlayerList: Node = $PlayerList
@onready var PlayerSpawner: MultiplayerSpawner = $PlayerSpawner

func _spawn_player(id: int) -> void:
	PlayerSpawner.spawn({ "id": id , "position": Vector2(randi() % 701 + 200, 350) })

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
