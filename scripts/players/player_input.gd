class_name PlayerInput extends Node

var direction: Vector2 = Vector2()
var attacking: bool = false

func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	if GameState.GAME_MENU_OPENED or Console.is_opened():
		direction = Vector2()
		attacking = false

	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	attacking = Input.is_action_pressed("attack")
