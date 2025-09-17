class_name Player extends CharacterBody2D

@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel

const WALK_SPEED: float = 450.0
const RUN_SPEED: float = 650.0
var direction: Vector2 = Vector2()
var current_speed: float = WALK_SPEED
var running: bool = false

##  Update the player display name
func update_player_name() -> void:
	NameLabel.set_text(Globals.NAME)

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	PlayerCamera.enabled = is_multiplayer_authority()
	if not is_multiplayer_authority(): return
	set_physics_process(multiplayer.is_server())
	EventBus.UpdatePlayerName.connect(update_player_name)
	NameLabel.set_text(Globals.NAME)

func _process(_delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	running = Input.is_action_pressed("run")

func _physics_process(_delta: float) -> void:
	# Stop input handling if the menu or console is opened
	if GameState.GAME_MENU_OPENED or Console.is_opened():
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.y = move_toward(velocity.y, 0, current_speed)
		return

	if running:
		current_speed = RUN_SPEED
	else:
		current_speed = WALK_SPEED
	if direction:
		velocity.x = direction.x * current_speed
		velocity.y = direction.y * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.y = move_toward(velocity.y, 0, current_speed)
	move_and_slide()
