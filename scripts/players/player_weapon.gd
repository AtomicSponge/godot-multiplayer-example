class_name PlayerWeapon extends NetworkWeapon2D

var bullet: PackedScene = preload("res://scenes/players/bullet.tscn")

@onready var input = $"../PlayerInput"
@onready var fireLocation: Marker2D = $"../WeaponSprite/FireLocation"

var fire_cooldown: float = 0.15
var last_fire: int = -1

func _ready() -> void:
	NetworkTime.on_tick.connect(_tick)

func _can_fire() -> bool:
	return NetworkTime.seconds_between(last_fire, NetworkTime.tick) >= fire_cooldown

func _can_peer_use(peer_id: int) -> bool:
	return peer_id == input.get_multiplayer_authority()

func _after_fire(_projectile: Node2D):
	last_fire = get_fired_tick()

func _spawn() -> Node2D:
	var b: Bullet = bullet.instantiate() as Bullet
	get_tree().root.add_child(b)
	b.global_position = fireLocation.global_position
	b.look_at(input.mousePosition)
	return b

func _tick(_delta: float, _t: int) -> void:
	if input.attacking:
		fire()
