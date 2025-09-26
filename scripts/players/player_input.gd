class_name PlayerInput extends Node

var direction: Vector2 = Vector2()

func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)

func _process(_delta: float) -> void:
	pass
