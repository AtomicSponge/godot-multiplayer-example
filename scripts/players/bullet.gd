class_name Bullet extends Area2D

@onready var LifeTimer = $LifeTimer

var speed = 750

func _ready() -> void:
	NetworkTime.on_tick.connect(_on_tick)
	LifeTimer.start()

func _on_tick(delta: float, _tick: float) -> void:
	if LifeTimer.is_stopped():
		queue_free()
	position += transform.x * speed * delta
