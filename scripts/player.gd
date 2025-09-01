extends CharacterBody2D

@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel

const SPEED: float = 500.0
const JUMP_VELOCITY: float = -800.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

##  Update the player display name
func update_player_name() -> void:
	NameLabel.set_text(Globals.NAME)

func _ready() -> void:
	PlayerCamera.enabled = is_multiplayer_authority()
	if not is_multiplayer_authority(): return
	EventBus.UpdatePlayerName.connect(update_player_name)
	NameLabel.set_text(Globals.NAME)

func _input(_event: InputEvent) -> void:
	if not is_multiplayer_authority(): return

	if Globals.GAME_MENU_OPENED or Console.is_opened():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		return

	# Get the input direction and handle the movement/deceleration.
	var direction_x: float = Input.get_axis("move_left", "move_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var direction_y: float = Input.get_axis("move_up", "move_down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return

	if event.is_action_pressed("game_menu") and Input.is_action_just_pressed("game_menu") and Globals.GAME_MENU_OPENED:
		Globals.GAME_MENU_OPENED = false
		UiController.close_all_menus()
	elif event.is_action_pressed("game_menu") and Input.is_action_just_pressed("game_menu") and not Globals.GAME_MENU_OPENED:
		Globals.GAME_MENU_OPENED = true
		UiController.open_menu("GameUI")
