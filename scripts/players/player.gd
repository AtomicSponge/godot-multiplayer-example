class_name Player extends CharacterBody2D

var bullet: PackedScene = preload("res://scenes/players/bullet.tscn")

@onready var PlayerSprite: AnimatedSprite2D = $PlayerSprite
@onready var PlayerHitbox: CollisionShape2D = $PlayerHitbox
@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel
@onready var WeaponSprite: Sprite2D = $WeaponSprite
@onready var FireLocation: Marker2D = $WeaponSprite/FireLocation
@onready var ShotTimer: Timer = $ShotTimer
@onready var RespawnTimer: Timer = $RespawnTimer

enum MovementStates { IDLE, WALKING, RUNNING }
@export var moveState: MovementStates = MovementStates.IDLE

const WALK_SPEED: float = 450.0
const RUN_SPEED: float = 650.0
var direction: Vector2 = Vector2()
@export var lookingLeft: bool = false
@export var alive: bool = true

##  Update the player display name
func update_player_name() -> void:
	NameLabel.set_text(Globals.NAME)

##  Called when the player dies.
func die() -> void:
	alive = false
	PlayerHitbox.set_deferred("disabled", true)
	hide()
	RespawnTimer.start()

##  Called when the player respawns.
func respawn() -> void:
	var spawn_position: Area2D = GameState.find_player_spawn()
	position = spawn_position.position
	show()
	PlayerHitbox.set_deferred("disabled", false)
	alive = true

##  Fire weapon.  Called as an RPC.
@rpc("any_peer", "call_local")
func fire_weapon() -> void:
	var b: Bullet = bullet.instantiate()
	add_child(b)
	b.global_position = FireLocation.global_position
	b.rotation = WeaponSprite.rotation

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	PlayerCamera.enabled = is_multiplayer_authority()
	if not is_multiplayer_authority(): return
	EventBus.UpdatePlayerName.connect(update_player_name)
	RespawnTimer.timeout.connect(respawn)
	NameLabel.set_text(Globals.NAME)
	PlayerSprite.play("Idle")

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	# Stop input if the menu or console is opened, or not alive
	if GameState.GAME_MENU_OPENED or Console.is_opened(): return
	if not alive: return

	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		if Input.is_action_pressed("run"):
			moveState = MovementStates.RUNNING
		else:
			moveState = MovementStates.WALKING
	else:
		moveState = MovementStates.IDLE

	if get_local_mouse_position().x < 0:
		lookingLeft = true
	else:
		lookingLeft = false
	WeaponSprite.look_at(get_global_mouse_position())

	if Input.is_action_pressed("attack") and ShotTimer.is_stopped():
		fire_weapon.rpc()
		ShotTimer.start()

func _physics_process(_delta: float) -> void:
	# Stop movement if the menu or console is opened
	if GameState.GAME_MENU_OPENED or Console.is_opened():
		moveState = MovementStates.IDLE
	if not alive:
		moveState = MovementStates.IDLE

	if lookingLeft:
		PlayerSprite.flip_h = true
		WeaponSprite.flip_v = true
	else:
		PlayerSprite.flip_h = false
		WeaponSprite.flip_v = false

	match moveState:
		MovementStates.IDLE:
			velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
			velocity.y = move_toward(velocity.y, 0, WALK_SPEED)
			PlayerSprite.play("Idle")
		MovementStates.WALKING:
			velocity.x = direction.x * WALK_SPEED
			velocity.y = direction.y * WALK_SPEED
			PlayerSprite.play("Move")
		MovementStates.RUNNING:
			velocity.x = direction.x * RUN_SPEED
			velocity.y = direction.y * RUN_SPEED
			PlayerSprite.play("Move", 2.0)  #  Double speed

	move_and_slide()
