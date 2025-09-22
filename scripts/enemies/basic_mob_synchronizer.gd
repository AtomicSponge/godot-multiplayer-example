extends MultiplayerSynchronizer

@onready var basicMob = get_parent()

func _on_chase_area_body_entered(body: Node2D) -> void:
	if not is_inside_tree() or not multiplayer.has_multiplayer_peer() or not is_multiplayer_authority():
		return
	if basicMob.targetPlayer == null and body is Player:
		basicMob.set_target_player(body)

func _on_loss_area_body_exited(body: Node2D) -> void:
	if not is_inside_tree() or not multiplayer.has_multiplayer_peer() or not is_multiplayer_authority():
		return
	if body == basicMob.targetPlayer:
		basicMob.set_target_player(null)
