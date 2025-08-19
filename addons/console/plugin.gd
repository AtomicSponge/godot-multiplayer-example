@tool
extends EditorPlugin

const AUTOLOAD_NAME = "Console"
const PATH = "res://addons/console/"

func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, str(PATH + "console.tscn"))

func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
