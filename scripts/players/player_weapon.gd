class_name PlayerWeapon extends NetworkWeapon

var bullet: PackedScene = preload("res://scenes/players/bullet.tscn")

@onready var player = get_parent()
@onready var input = $"../PlayerInput"
@onready var fireLocation: Marker2D = $"../WeaponSprite/FireLocation"

var fire_cooldown: float = 0.10
var last_fire: int = -1

func _ready() -> void:
	NetworkTime.on_tick.connect(_tick)

func _can_fire() -> bool:
	return NetworkTime.seconds_between(last_fire, NetworkTime.tick) >= fire_cooldown

func _can_peer_use(peer_id: int) -> bool:
	return peer_id == input.get_multiplayer_authority()

func _after_fire(projectile: Node):
	last_fire = get_fired_tick()

	for t in range(get_fired_tick(), NetworkTime.tick):
		if projectile.is_queued_for_deletion():
			break
		projectile._tick(NetworkTime.ticktime, t)

func _spawn() -> Bullet:
	var b: Bullet = bullet.instantiate() as Bullet
	get_tree().current_scene.get_node("/root/Game/Bullets").add_child(b)
	b.global_position = fireLocation.global_position
	b.look_at(player.mousePosition)
	return b

func _tick(_delta: float, _t: int) -> void:
	if input.attacking:
		fire()
