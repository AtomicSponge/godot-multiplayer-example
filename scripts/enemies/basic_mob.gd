##  An enemy that will wander around or chase the player if they come in range
class_name BasicMob extends Enemy

@onready var MobSprite: AnimatedSprite2D = $MobSprite
@onready var MovementTimer: Timer = $MovementTimer

const WALK_SPEED: float = 100.0
const CHASE_SPEED: float = 450.0

var directionX: float = (randi() % 3) - 1
var directionY: float = (randi() % 3) - 1

var targetPlayer: Player = null

##  Randomly change enemy direction durring its walk cycle.
func change_direction() -> void:
	if randf() >= 0.33:
		directionX = (randi() % 3) - 1
	if randf() >= 0.33:
		directionY = (randi() % 3) - 1
	MovementTimer.start(randi() % 2)

##  Set the player to chase.  Called in the synchronizer.
func set_target_player(player: Player) -> void:
	targetPlayer = player

func _ready() -> void:
	if multiplayer.is_server():
		MovementTimer.timeout.connect(change_direction)
		moveState = MovementStates.WALKING

func _physics_process(_delta: float) -> void:
	if targetPlayer != null:
		change_state(moveState, MovementStates.CHASING)
	else:
		change_state(moveState, MovementStates.WALKING)

	match moveState:
		MovementStates.WALKING:
			velocity.x = directionX * WALK_SPEED
			velocity.y = directionY * WALK_SPEED
			MobSprite.play("Fly")
		MovementStates.CHASING:
			var pos: Vector2 = position.direction_to(targetPlayer.position)
			velocity.x = pos.x * CHASE_SPEED
			velocity.y = pos.y * CHASE_SPEED
			MobSprite.play("Fly", 2.0)
		MovementStates.ATTACKING:
			velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
			velocity.y = move_toward(velocity.y, 0, WALK_SPEED)
			MobSprite.play("Fly")

	move_and_slide()
