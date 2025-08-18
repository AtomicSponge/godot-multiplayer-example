extends MultiplayerSpawner

@onready var PlayerList: Node = $PlayerList

var PLAYER: PackedScene = preload("res://scenes/player.tscn")

func spawn_player(id: int) -> void:
	var player: Node = PLAYER.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)
	player.position = Vector2(randi() % 401 + 400, 350)

func remove_player(id: int) -> void:
	if not multiplayer.is_server(): return

	for player in PlayerList.get_children():
		if player.name == str(id):
			PlayerList.remove_child(player)
			player.queue_free()

func _ready() -> void:
	if not multiplayer.is_server(): return
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)

	if not OS.has_feature("dedicated_server"):
		spawn_player(1)
