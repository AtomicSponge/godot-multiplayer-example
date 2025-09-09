class_name Player extends CharacterBody2D

@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel

const WALK_SPEED: float = 450.0
const RUN_SPEED: float = 650.0
var current_speed: float = 0.0

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

	# Stop input handling if the menu or console is opened
	if GameState.GAME_MENU_OPENED or Console.is_opened():
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.y = move_toward(velocity.y, 0, current_speed)
		return

	if Input.is_action_pressed("run"):
		current_speed = RUN_SPEED
	else:
		current_speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration
	var direction_x: float = Input.get_axis("move_left", "move_right")
	if direction_x:
		velocity.x = direction_x * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	var direction_y: float = Input.get_axis("move_up", "move_down")
	if direction_y:
		velocity.y = direction_y * current_speed
	else:
		velocity.y = move_toward(velocity.y, 0, current_speed)

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	move_and_slide()
