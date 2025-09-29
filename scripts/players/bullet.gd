class_name Bullet extends Area2D

@onready var LifeTimer = $LifeTimer

var speed = 750

@rpc("call_local")
func remove_mob(body: Node2D) -> void:
	if body == null: return
	body.queue_free()

func _ready() -> void:
	LifeTimer.start()

func _process(delta: float) -> void:
	if LifeTimer.is_stopped():
		queue_free()
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		return
	if body is Enemy:
		remove_mob.rpc(body)
	queue_free()
