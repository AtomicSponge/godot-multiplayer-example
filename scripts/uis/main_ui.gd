extends Control

func _on_host_game_btn_pressed() -> void:
	pass # Replace with function body.

func _on_join_game_btn_pressed() -> void:
	pass # Replace with function body.

func _on_settings_btn_pressed() -> void:
	UiController.open_menu("SettingsUI")

func _on_quit_btn_pressed() -> void:
	Globals.quit_game()
