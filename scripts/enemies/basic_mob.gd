class_name BasicMob extends Enemy

@onready var MovementTimer: Timer = $MovementTimer

const WALK_SPEED: float = 100.0
const CHASE_SPEED: float = 500.0

var direction_x: float = (randi() % 3) - 1
var direction_y: float = (randi() % 3) - 1

var targetPlayer: Player = null

func change_direction() -> void:
	if randf() >= 0.33:
		direction_x = (randi() % 3) - 1
	if randf() >= 0.33:
		direction_y = (randi() % 3) - 1
	MovementTimer.start(randi() % 2)

func change_state(_old_state: int, _new_state: int) -> void:
	pass

func _ready() -> void:
	if multiplayer.is_server():
		MovementTimer.timeout.connect(change_direction)
		moveState = MovementStates.WALKING

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if targetPlayer != null:
		change_state(moveState, MovementStates.CHASING)
	
	match moveState:
		MovementStates.WALKING:
			velocity.x = direction_x * WALK_SPEED
			velocity.y = direction_y * WALK_SPEED
		MovementStates.CHASING:
			look_at(targetPlayer.position)
		MovementStates.ATTACKING:
			velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
			velocity.y = move_toward(velocity.y, 0, WALK_SPEED)

	move_and_slide()
