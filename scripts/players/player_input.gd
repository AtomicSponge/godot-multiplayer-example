class_name PlayerInput extends BaseNetInput

var direction: Vector2 = Vector2.ZERO		##  Input direction vector
var attacking: bool = false					##  Is the player attacking
var mousePosition: Vector2 = Vector2.ZERO	##  Screen position of mouse
var lookingLeft: bool = false				##  Direction player is facing

#func _ready() -> void:
	#NetworkTime.before_tick_loop.connect(_gather)

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return

	if event is InputEventMouseMotion:
		mousePosition = event.position

func _gather() -> void:
	#if not is_multiplayer_authority():
		#return
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	attacking = Input.is_action_pressed("attack")
	#mousePosition = get_global_mouse_position()
	#if get_local_mouse_position().x < 0:
		#lookingLeft = true
	#else:
		#lookingLeft = false
