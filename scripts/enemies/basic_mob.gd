class_name BasicMob extends CharacterBody2D

@onready var MovementTimer: Timer = $MovementTimer

const WALK_SPEED: float = 200.0
const CHASE_SPEED: float = 500.0

var direction_x: float = (randi() % 3) - 1
var direction_y: float = (randi() % 3) - 1

enum MovementStates { WALKING, CHASING, ATTACKING }

var moveState: MovementStates = MovementStates.WALKING

func change_direction() -> void:
	direction_x = (randi() % 3) - 1
	direction_y = (randi() % 3) - 1
	MovementTimer.start(randi() % 2)

func _ready() -> void:
	MovementTimer.timeout.connect(change_direction)

func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server():
		return

	if moveState == MovementStates.WALKING:
		velocity.x = direction_x * WALK_SPEED
		velocity.y = direction_y * WALK_SPEED
	elif moveState == MovementStates.CHASING:
		velocity.x = direction_x * CHASE_SPEED
		velocity.y = direction_y * CHASE_SPEED
	elif moveState == MovementStates.ATTACKING:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.y = move_toward(velocity.y, 0, WALK_SPEED)

	move_and_slide()
