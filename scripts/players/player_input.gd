class_name PlayerInput extends Node2D

var direction: Vector2 = Vector2(0, 0)	##  Input direction vector
var attacking: bool = false				##  Is the player attacking
var mousePosition: Vector2 = Vector2()	##  Screen position of mouse
var lookingLeft: bool = false			##  Direction player is facing

func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	attacking = Input.is_action_pressed("attack")
	mousePosition = get_global_mouse_position()
	if get_local_mouse_position().x < 0:
		lookingLeft = true
	else:
		lookingLeft = false
