extends Node

func say_command(text: String) -> void:
	Console.add_text(text)

func _enter_tree() -> void:
	Console.add_command("say", say_command)
