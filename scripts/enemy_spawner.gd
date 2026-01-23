extends MultiplayerSpawner

func _make_enemy(data: Dictionary) -> Node:
	var enemy: Node = load(Globals.Assets.basic_mob).instantiate()
	enemy.position = data.position
	return enemy

func _enter_tree() -> void:
	set_spawn_function(_make_enemy)
