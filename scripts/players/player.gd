class_name Player extends CharacterBody2D

@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel

const SPEED: float = 500.0

enum MovementStates { IDLE, WALKING }

var moveState: MovementStates = MovementStates.IDLE

var direction_x: float = 0.0
var direction_y: float = 0.0

##  Update the player display name
func update_player_name() -> void:
	NameLabel.set_text(Globals.NAME)

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	PlayerCamera.enabled = is_multiplayer_authority()
	if not is_multiplayer_authority(): return
	EventBus.UpdatePlayerName.connect(update_player_name)
	NameLabel.set_text(Globals.NAME)

func _input(_event: InputEvent) -> void:
	if not is_multiplayer_authority(): return

	# Stop the player if the menu or console is opened
	if GameState.GAME_MENU_OPENED or Console.is_opened():
		moveState = MovementStates.IDLE
		return

	# Get the input direction and handle the movement/deceleration
	direction_x = Input.get_axis("move_left", "move_right")
	direction_y = Input.get_axis("move_up", "move_down")
	if direction_x != 0.0 or direction_y != 0.0:
		moveState = MovementStates.WALKING
	else:
		moveState = MovementStates.IDLE

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	if moveState == MovementStates.IDLE:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	elif moveState == MovementStates.WALKING:
		velocity.x = direction_x * SPEED
		velocity.y = direction_y * SPEED
	move_and_slide()
