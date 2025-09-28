##  A node representing a player scene
class_name Player extends CharacterBody2D

##  Reference to the player input node
@export var input: PlayerInput
##  Reference to the player bullet scene
var bullet: PackedScene = preload("res://scenes/players/bullet.tscn")

@onready var PlayerSprite: AnimatedSprite2D = $PlayerSprite
@onready var PlayerHitbox: CollisionShape2D = $PlayerHitbox
@onready var PlayerCamera: Camera2D = $PlayerCamera
@onready var NameLabel: Label = $NameLabel
@onready var WeaponSprite: Sprite2D = $WeaponSprite
@onready var FireLocation: Marker2D = $WeaponSprite/FireLocation
@onready var ShotTimer: Timer = $ShotTimer
@onready var RespawnTimer: Timer = $RespawnTimer

@export var player_id: int = 1:
	set(id):
		player_id = id

const SPEED: float = 450.0
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

##  Run animations.
func apply_animation(_delta: float) -> void:
	if GameState.GAME_MENU_OPENED or Console.is_opened() or not alive:
		PlayerSprite.play("Idle")
		return

	if input.lookingLeft:
		PlayerSprite.flip_h = true
		WeaponSprite.flip_v = true
	else:
		PlayerSprite.flip_h = false
		WeaponSprite.flip_v = false

	WeaponSprite.look_at(input.mousePosition)

	if input.direction:
		PlayerSprite.play("Move")
	else:
		PlayerSprite.play("Idle")

##  Apply player input.
func apply_input(_delta: float, _tick: float, _is_fresh: bool) -> void:
	# Stop movement if the menu or console is opened
	if GameState.GAME_MENU_OPENED or Console.is_opened() or not alive:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		return

	if input.direction:
		velocity.x = input.direction.x * SPEED
		velocity.y = input.direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if input.attacking and ShotTimer.is_stopped():
		fire_weapon.rpc()
		ShotTimer.start()

func _ready() -> void:
	await get_tree().process_frame
	set_multiplayer_authority(1)
	input.set_multiplayer_authority(player_id)
	$RollbackSynchronizer.process_settings()
	#  Configure the player for the controlling client
	if multiplayer.get_unique_id() == player_id:
		PlayerCamera.make_current()
		EventBus.UpdatePlayerName.connect(update_player_name)
		RespawnTimer.timeout.connect(respawn)
		NameLabel.set_text(Globals.NAME)
	#  Disable this player for other clients
	else:
		PlayerCamera.enabled = false

func _process(delta: float) -> void:
	apply_animation(delta)

func _rollback_tick(delta: float, tick: float, is_fresh: bool) -> void:
	apply_input(delta, tick, is_fresh)

	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor
