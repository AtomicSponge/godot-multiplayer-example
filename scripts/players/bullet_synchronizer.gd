extends MultiplayerSynchronizer

@onready var bullet = get_parent()

func _on_bullet_body_entered(body: Node2D) -> void:
	if body is Player:
		return
	if body is Enemy:
		body.queue_free()
	queue_free()
