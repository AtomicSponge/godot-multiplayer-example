class_name Player extends CharacterBody2D

@onready var PlayerSprite: AnimatedSprite2D = $PlayerSprite
@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel

enum MovementStates { IDLE, WALKING, RUNNING }
@export var moveState: MovementStates = MovementStates.IDLE

const WALK_SPEED: float = 450.0
const RUN_SPEED: float = 650.0
var direction: Vector2 = Vector2()
@export var movingLeft: bool = false

##  Update the player display name
func update_player_name() -> void:
	NameLabel.set_text(Globals.NAME)

##  Change states.  Returns old state.
func change_state(old_state: MovementStates, new_state: MovementStates) -> MovementStates:
	moveState = new_state
	return old_state

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	PlayerCamera.enabled = is_multiplayer_authority()
	set_physics_process(multiplayer.is_server())
	if not is_multiplayer_authority(): return
	EventBus.UpdatePlayerName.connect(update_player_name)
	NameLabel.set_text(Globals.NAME)
	PlayerSprite.play("Idle")

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		if direction.x < 0:
			movingLeft = true
		else:
			movingLeft = false
		if Input.is_action_pressed("run"):
			change_state(moveState, MovementStates.RUNNING)
		else:
			change_state(moveState, MovementStates.WALKING)
	else:
		change_state(moveState, MovementStates.IDLE)

func _physics_process(_delta: float) -> void:
	# Stop input handling if the menu or console is opened
	if GameState.GAME_MENU_OPENED or Console.is_opened():
		change_state(moveState, MovementStates.IDLE)

	match moveState:
		MovementStates.IDLE:
			velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
			velocity.y = move_toward(velocity.y, 0, WALK_SPEED)
			PlayerSprite.play("Idle")
		MovementStates.WALKING:
			velocity.x = direction.x * WALK_SPEED
			velocity.y = direction.y * WALK_SPEED
			if movingLeft:
				PlayerSprite.flip_h = true
			else:
				PlayerSprite.flip_h = false
			PlayerSprite.play("Move")
		MovementStates.RUNNING:
			velocity.x = direction.x * RUN_SPEED
			velocity.y = direction.y * RUN_SPEED
			if movingLeft:
				PlayerSprite.flip_h = true
			else:
				PlayerSprite.flip_h = false
			PlayerSprite.play("Move", 2.0)  #  Double speed

	move_and_slide()
