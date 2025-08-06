extends Control

var _ui_node: Node
var _ui_ref: Array[String]

const _menus: Dictionary[String, PackedScene] = {
	"HostUI": preload("res://uis/host_ui.tscn"),
	"LobbyUI": preload("res://uis/lobby_ui.tscn"),
	"MainUI": preload("res://uis/main_ui.tscn"),
	"SearchUI": preload("res://uis/search_ui.tscn"),
	"SettingsUI": preload("res://uis/settings_ui.tscn")
}

func open_menu(menu_name: String) -> void:
	_clear_menu_mem()
	_ui_ref.push_back(menu_name)
	_ui_node.add_child(_menus[menu_name].instantiate())

func close_menu() -> void:
	_clear_menu_mem()
	_ui_ref.pop_back()
	if not _ui_ref.is_empty():
		open_menu(_ui_ref.back())

func _clear_menu_mem() -> void:
	for node in _ui_node.get_children():
		_ui_node.remove_child(node)
		node.queue_free()
