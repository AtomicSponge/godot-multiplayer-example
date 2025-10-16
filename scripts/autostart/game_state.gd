extends Node

# Game variables
var GAME_RUNNING: bool = false		##  Is the game running
var GAME_MENU_OPENED: bool = false	##  Is the game menu opened

##  Node to track player spawn locations.  Gets set when a level is loaded.
var playerSpawners: Node = null

##  Find the player spawn points and returns an empty one.
func find_player_spawn() -> Area2D:
	if playerSpawners == null:  return null
	var spawn_position: Area2D = null
	#  Look for any overlapping bodies and pick an empty spawn location
	for spawner in playerSpawners.get_children():
		if spawner is Area2D:
			if spawner.has_overlapping_bodies():
				continue
			else:
				spawn_position = spawner
				break
	return spawn_position
