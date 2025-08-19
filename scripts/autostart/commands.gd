extends Node

func say_command(args: String) -> void:
	Console.add_text(args)

func _enter_tree() -> void:
	Console.add_command("say", say_command)
