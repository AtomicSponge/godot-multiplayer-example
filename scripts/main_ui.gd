extends Control

func _on_host_game_btn_pressed() -> void:
	SceneManager.SwitchScene("lobby_scene")

func _on_join_game_btn_pressed() -> void:
	SceneManager.SwitchScene("lobby_scene")

func _on_settings_btn_pressed() -> void:
	SceneManager.SwitchScene("settings_scene")

func _on_quit_btn_pressed() -> void:
	SceneManager.QuitGame()
