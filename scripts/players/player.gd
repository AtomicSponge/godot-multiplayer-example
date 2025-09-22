class_name Player extends CharacterBody2D

var bullet: PackedScene = preload("res://scenes/players/bullet.tscn")

@onready var PlayerSprite: AnimatedSprite2D = $PlayerSprite
@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel
@onready var WeaponSprite: Sprite2D = $WeaponSprite
@onready var FireLocation: Marker2D = $WeaponSprite/FireLocation

enum MovementStates { IDLE, WALKING, RUNNING }
@export var moveState: MovementStates = MovementStates.IDLE

const WALK_SPEED: float = 450.0
const RUN_SPEED: float = 650.0
var direction: Vector2 = Vector2()
@export var lookingLeft: bool = false

##  Update the player display name
func update_player_name() -> void:
	NameLabel.set_text(Globals.NAME)

@rpc("any_peer", "call_local")
func fire_weapon() -> void:
	var b: Bullet = bullet.instantiate()
	add_child(b)
	b.position = FireLocation.position
	b.look_at(get_global_mouse_position())

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	PlayerCamera.enabled = is_multiplayer_authority()
	if not is_multiplayer_authority(): return
	EventBus.UpdatePlayerName.connect(update_player_name)
	NameLabel.set_text(Globals.NAME)
	PlayerSprite.play("Idle")

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
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

	if Input.is_action_pressed("attack"):
		fire_weapon.rpc()

func _physics_process(_delta: float) -> void:
	# Stop movement if the menu or console is opened
	if GameState.GAME_MENU_OPENED or Console.is_opened():
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
