class_name Bullet extends Area2D

@onready var LifeTimer = $LifeTimer

var speed = 750

func _ready() -> void:
	if not multiplayer.is_server():
		set_process(false)
	else:
		LifeTimer.start()

func _process(delta: float) -> void:
	if LifeTimer.is_stopped():
		queue_free()
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if not is_inside_tree() or not multiplayer.has_multiplayer_peer() or not is_multiplayer_authority():
		return
	if body is Player:
		return
	if body is Enemy:
		body.queue_free()
	queue_free()
