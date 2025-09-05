class_name BasicMob extends RigidBody2D

const SPEED: float = 350.0
const CHASE_SPEED: float = 500.0

enum States { WALKING, CHASING, ATTACKING }

var state: States = States.WALKING

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
