class_name Enemy extends CharacterBody2D

func _ready() -> void:
	set_physics_process(multiplayer.is_server())
	if not multiplayer.is_server():
		set_process(false)
