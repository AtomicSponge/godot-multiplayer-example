##  Base class for creating a new enemy scene
class_name Enemy extends CharacterBody2D

enum MovementStates { IDLE, WALKING, CHASING, ATTACKING }
var moveState: MovementStates = MovementStates.IDLE

@export var movingLeft: bool = false

##  Change states.  Override to implement custom functionality.
func change_state(old_state: MovementStates, new_state: MovementStates) -> MovementStates:
	moveState = new_state
	return old_state
