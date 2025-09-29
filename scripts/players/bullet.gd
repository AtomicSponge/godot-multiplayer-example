class_name Bullet extends Area2D

@onready var LifeTimer = $LifeTimer

var speed = 750

func _ready() -> void:
	LifeTimer.start()

func _process(delta: float) -> void:
	if LifeTimer.is_stopped():
		queue_free()
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if not multiplayer.is_server():
		return
	if body is Player:
		return
	if body is Enemy:
		body.queue_free()
	queue_free()
