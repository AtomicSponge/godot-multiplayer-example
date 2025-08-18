extends CanvasLayer

func _on_resume_game_btn_pressed() -> void:
	UiController.close_all_menus()
	Globals.game_menu_opened = false

func _on_settings_btn_pressed() -> void:
	UiController.open_menu("SettingsUI")

func _on_quit_btn_pressed() -> void:
	EventBus.EndGame.emit()
	UiController.close_all_menus()
	Globals.game_menu_opened = false
	UiController.open_menu("MainUI")
