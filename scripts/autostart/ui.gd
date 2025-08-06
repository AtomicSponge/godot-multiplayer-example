extends Control

const _interfaces: Dictionary[String, PackedScene] = {
	"HostUI": preload("res://uis/host_ui.tscn"),
	"LobbyUI": preload("res://uis/lobby_ui.tscn"),
	"MainUI": preload("res://uis/main_ui.tscn"),
	"SearchUI": preload("res://uis/search_ui.tscn"),
	"SettingsUI": preload("res://uis/settings_ui.tscn")
}

func open_menu() -> void:
	pass
