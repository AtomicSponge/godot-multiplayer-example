@tool
extends EditorPlugin

const AUTOLOAD_NAME = "Console"
const NODE_NAME = "Console"
const PATH = "res://addons/console/"

func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, str(PATH + "console.tscn"))
	#add_custom_type(NODE_NAME, "Node", preload(PATH + "ui_anchor.gd"), preload(PATH + "icon.svg"))

func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
	#remove_custom_type(NODE_NAME)
