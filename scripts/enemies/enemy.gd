##  Base class for creating a new enemy scene.
class_name Enemy extends CharacterBody2D

##  List of movement states.
enum MovementStates {
	IDLE,		##  Enemy is standing still.
	WALKING,	##  Enemy is walking around.
	CHASING,	##  Enemy is chasing a player.
	ATTACKING	##  Enemy is attacking a player.
}
##  Current movement state.  Exported for synchronizer.
@export var moveState: MovementStates = MovementStates.IDLE

##  If the enemy is moving to the left.  For animation purposes.  Exported for synchronizer.
@export var movingLeft: bool = false

##  Change states.  Override to implement custom functionality.
func change_state(old_state: MovementStates, new_state: MovementStates) -> MovementStates:
	moveState = new_state
	return old_state
