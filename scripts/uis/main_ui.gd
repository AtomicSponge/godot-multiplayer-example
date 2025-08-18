extends CanvasLayer

func _on_host_game_btn_pressed() -> void:
	UiController.open_menu("HostUI")
	#UiController.close_all_menus()
	#NetworkHandler.start_server()

func _on_join_game_btn_pressed() -> void:
	UiController.open_menu("JoinUI")
	#UiController.close_all_menus()
	#NetworkHandler.start_client()

func _on_settings_btn_pressed() -> void:
	UiController.open_menu("SettingsUI")

func _on_quit_btn_pressed() -> void:
	Globals.quit_game()
