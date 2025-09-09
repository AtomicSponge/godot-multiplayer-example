class_name BasicMob extends CharacterBody2D

const WALK_SPEED: float = 350.0
const CHASE_SPEED: float = 500.0

enum MovementStates { WALKING, CHASING, ATTACKING }

var moveState: MovementStates = MovementStates.WALKING

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return

	var direction_x: float = -1
	var direction_y: float = -1

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
