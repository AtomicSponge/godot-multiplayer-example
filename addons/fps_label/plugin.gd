@tool
extends EditorPlugin

const NODE_NAME = "FPSLabel"
const PATH = "res://addons/fps_label/"

func _enter_tree() -> void:
	add_custom_type(NODE_NAME, "Label", preload(PATH + "fps_label.gd"), preload(PATH + "icon.svg"))

func _exit_tree() -> void:
	remove_custom_type(NODE_NAME)
