extends Node

func _ready() -> void:
	Ui._ui_node = $UI
	Ui.open_menu("MainUI")
