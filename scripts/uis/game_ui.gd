class_name GameUI extends CanvasLayer

func _on_resume_game_btn_pressed() -> void:
	UiController.close_all_menus()
	GameState.GAME_MENU_OPENED = false

func _on_settings_btn_pressed() -> void:
	UiController.open_menu("SettingsUI")

func _on_quit_btn_pressed() -> void:
	UiController.close_all_menus()
	GameState.GAME_MENU_OPENED = false
	EventBus.EndGame.emit()
