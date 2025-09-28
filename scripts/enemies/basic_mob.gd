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
	if not multiplayer.is_server(): return
	MovementTimer.timeout.connect(change_direction)
	moveState = MovementStates.WALKING
	change_direction()

func _process(_delta: float) -> void:
	#  Play animations
	if movingLeft:
		MobSprite.flip_h = true
	else:
		MobSprite.flip_h = false
	match moveState:
		MovementStates.CHASING:
			MobSprite.play("Fly", 4.0)  #  Quad speed
		_:
			MobSprite.play("Fly")

#func _rollback_tick(_delta: float, _tick: float, _is_fresh: bool) -> void:
func _physics_process(_delta: float) -> void:
	#  Process moving on server only
	if multiplayer.is_server():
		if targetPlayer != null:
			change_state(moveState, MovementStates.CHASING)
		else:
			change_state(moveState, MovementStates.WALKING)

		match moveState:
			MovementStates.WALKING:
				velocity.x = directionX * WALK_SPEED
				velocity.y = directionY * WALK_SPEED
				if directionX < 0:
					movingLeft = true
				else:
					movingLeft = false
			MovementStates.CHASING:
				var pos: Vector2 = position.direction_to(targetPlayer.position)
				velocity.x = pos.x * CHASE_SPEED
				velocity.y = pos.y * CHASE_SPEED
				if pos.x < 0:
					movingLeft = true
				else:
					movingLeft = false
			_:
				velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
				velocity.y = move_toward(velocity.y, 0, WALK_SPEED)
		move_and_slide()
