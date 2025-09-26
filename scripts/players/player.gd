class_name Player extends CharacterBody2D

var bullet: PackedScene = preload("res://scenes/players/bullet.tscn")

@onready var input: PlayerInput = $PlayerInput

@onready var PlayerSprite: AnimatedSprite2D = $PlayerSprite
@onready var PlayerHitbox: CollisionShape2D = $PlayerHitbox
@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel
@onready var WeaponSprite: Sprite2D = $WeaponSprite
@onready var FireLocation: Marker2D = $WeaponSprite/FireLocation
@onready var ShotTimer: Timer = $ShotTimer
@onready var RespawnTimer: Timer = $RespawnTimer

const SPEED: float = 450.0
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

	#direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if get_local_mouse_position().x < 0:
		lookingLeft = true
	else:
		lookingLeft = false
	WeaponSprite.look_at(get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	# Stop movement if the menu or console is opened
	if GameState.GAME_MENU_OPENED or Console.is_opened() or not alive:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		PlayerSprite.play("Idle")
		return

	if lookingLeft:
		PlayerSprite.flip_h = true
		WeaponSprite.flip_v = true
	else:
		PlayerSprite.flip_h = false
		WeaponSprite.flip_v = false

	if input.direction:
		velocity.x = input.direction.x * SPEED
		velocity.y = input.direction.y * SPEED
		PlayerSprite.play("Move")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		PlayerSprite.play("Idle")
	
	if input.attacking and ShotTimer.is_stopped():
		fire_weapon.rpc()
		ShotTimer.start()

	move_and_slide()
