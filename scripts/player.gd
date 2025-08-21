extends CharacterBody2D

@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel

const SPEED: float = 400.0
const JUMP_VELOCITY: float = -800.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	PlayerCamera.enabled = is_multiplayer_authority()
	if not is_multiplayer_authority(): return
	NameLabel.set_text(Globals.NAME)

func _input(_event: InputEvent) -> void:
	if not is_multiplayer_authority(): return

	if Globals.GAME_MENU_OPENED or Console.is_opened():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		return

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return

	if event.is_action_pressed("game_menu") and Input.is_action_just_pressed("game_menu") and Globals.GAME_MENU_OPENED:
		Globals.GAME_MENU_OPENED = false
		UiController.close_all_menus()
		return
	if event.is_action_pressed("game_menu") and Input.is_action_just_pressed("game_menu") and not Globals.GAME_MENU_OPENED:
		Globals.GAME_MENU_OPENED = true
		UiController.open_menu("GameUI")
