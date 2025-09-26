class_name PlayerInput extends Node2D

var direction: Vector2 = Vector2(0, 0)
var attacking: bool = false
var mouse_position: Vector2 = Vector2()

func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	attacking = Input.is_action_pressed("attack")
	mouse_position = get_global_mouse_position()
