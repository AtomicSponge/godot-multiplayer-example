extends MultiplayerSpawner

@export var ENEMIES: Dictionary[String, String] = { "basic_mob": "res://scenes/enemies/basic_mob.tscn" }

func _make_enemy(data: Dictionary) -> Node:
	var enemy: Node = load(ENEMIES[data.type]).instantiate()
	enemy.position = data.position
	enemy.set_multiplayer_authority(1)
	return enemy

func _enter_tree() -> void:
	set_spawn_function(_make_enemy)
