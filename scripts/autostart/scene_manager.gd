extends Node

var Scenes: Dictionary = {
	"main_scene": "res://scenes/main_scene.tscn",
	"settings_scene": "res://scenes/settings_scene.tscn",
	"search_scene": "res://scenes/search_scene.tscn",
	"lobby_scene": "res://scenes/lobby_scene.tscn",
	"world_scene": "res://scenes/world_scene.tscn"
}

@onready var Fader = $Fader/AnimationPlayer

# Switch to the requested scene based on its alias
func SwitchScene(sceneAlias: String) -> void:
	get_tree().paused = true
	Fader.play("Fade")
	await Fader.animation_finished
	get_tree().change_scene_to_file(Scenes[sceneAlias])
	Fader.play_backwards("Fade")
	await Fader.animation_finished
	get_tree().paused = false

# Restart the current scene
func RestartScene() -> void:
	get_tree().paused = true
	Fader.play("Fade")
	await Fader.animation_finished
	get_tree().reload_current_scene()
	Fader.play_backwards("Fade")
	await Fader.animation_finished
	get_tree().paused = false

# Quit the game
func QuitGame() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
