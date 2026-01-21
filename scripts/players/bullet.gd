class_name Bullet extends Area2D

var speed: float = 800.0
var distance: float = 200000.0
var distance_left: float = 0.0

func _ready() -> void:
	NetworkTime.on_tick.connect(_tick)
	distance_left = distance

func _tick(delta: float, _t: int) -> void:
	position += transform.x * speed * delta
	distance_left -= speed

	if distance_left < 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not is_inside_tree() or not multiplayer.has_multiplayer_peer() or not multiplayer.is_server():
		return
	if body is Player:
		return
	if body is Enemy:
		body.queue_free()
	queue_free()
