extends Control

func _on_host_game_btn_pressed() -> void:
	#SceneManager.SwitchScene("lobby_scene")
	#SceneManager.SwitchScene("world_scene")
	hide()
	NetworkHandler.start_server()

func _on_join_game_btn_pressed() -> void:
	#SceneManager.SwitchScene("search_scene")
	#SceneManager.SwitchScene("world_scene")
	hide()
	NetworkHandler.start_client()

func _on_settings_btn_pressed() -> void:
	SceneManager.SwitchScene("settings_scene")

func _on_quit_btn_pressed() -> void:
	SceneManager.QuitGame()
