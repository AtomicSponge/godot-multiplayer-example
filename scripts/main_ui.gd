extends Control

func _on_host_game_btn_pressed() -> void:
	hide()
	NetworkHandler.start_server()

func _on_join_game_btn_pressed() -> void:
	hide()
	NetworkHandler.start_client()

func _on_settings_btn_pressed() -> void:
	pass

func _on_quit_btn_pressed() -> void:
	Globals.quit_game()
