extends Node2D

@onready var PlayerList: Node = $PlayerList
@onready var PlayerSpawner: MultiplayerSpawner = $PlayerSpawner

func spawn_player(id: int) -> void:
	PlayerSpawner.spawn({ "id": id, "position": Vector2(randi() % 701 + 200, 350) })

func remove_player(id: int) -> void:
	if not PlayerList.has_node(str(id)): return
	PlayerList.get_node(str(id)).queue_free()

func _ready() -> void:
	if not multiplayer.is_server(): return
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)

	for id in multiplayer.get_peers():
		spawn_player(id)

	if not OS.has_feature("dedicated_server"):
		spawn_player(1)
