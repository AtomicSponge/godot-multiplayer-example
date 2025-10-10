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
@onready var playerWeapon: Node = $PlayerWeapon
@onready var WeaponSprite: Sprite2D = $WeaponSprite

@export var player_id: int:
	set(id):
		player_id = id

const SPEED: float = 450.0
@export var alive: bool = true

##  Update the player display name
func update_player_name() -> void:
	NameLabel.set_text(Globals.NAME)

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
func apply_input() -> void:
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

func _ready() -> void:
	await get_tree().process_frame
	set_multiplayer_authority(1)
	input.set_multiplayer_authority(player_id)
	#  Configure the player for the controlling client
	if multiplayer.get_unique_id() == player_id:
		PlayerCamera.make_current()
		EventBus.UpdatePlayerName.connect(update_player_name)
		NameLabel.set_text(Globals.NAME)
	#  Disable this player for other clients
	else:
		PlayerCamera.enabled = false

func _process(delta: float) -> void:
	apply_animation(delta)

func _rollback_tick(_delta: float, _tick: int, _is_fresh: bool) -> void:
	apply_input()

	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor
