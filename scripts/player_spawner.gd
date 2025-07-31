extends Node

const PLAYER = preload("res://scenes/player.tscn")

func spawn_player(id: int) -> void:
	var player = PLAYER.instantiate()
	player.owner_id = id
	player.name = str(id)
	
	call_deferred("add_child", player)
