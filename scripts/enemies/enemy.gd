class_name Enemy extends CharacterBody2D

enum MovementStates { IDLE, WALKING, CHASING, ATTACKING }
var moveState: MovementStates = MovementStates.IDLE

##  Override in each enemy to implement state changing
func change_state(old_state: MovementStates, new_state: MovementStates) -> MovementStates:
	moveState = new_state
	return old_state

func _ready() -> void:
	#  Handle all enemy physics on server only
	set_physics_process(multiplayer.is_server())
