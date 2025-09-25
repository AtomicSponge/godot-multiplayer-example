extends Node

# Game variables
var GAME_RUNNING: bool = false		##  Is the game running
var GAME_MENU_OPENED: bool = false	##  Is the game menu opened

var playerSpawners: Node = null

##  Find the player spawn points and returns an empty one.
func find_player_spawns() -> Area2D:
	if playerSpawners == null:  return
	var spawn_position: Area2D = null
	#  Look for any overlapping bodies and pick an empty spawn location
	for spawner in GameState.playerSpawners.get_children():
		if spawner is Area2D:
			if spawner.has_overlapping_bodies():
				continue
			else:
				spawn_position = spawner
				break
	return spawn_position
