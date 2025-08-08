extends Control

func _on_resume_game_btn_pressed() -> void:
	UiController.close_menu()

func _on_settings_btn_pressed() -> void:
	UiController.open_menu("SettingsUI")

func _on_quit_btn_pressed() -> void:
	Globals.quit_game()
