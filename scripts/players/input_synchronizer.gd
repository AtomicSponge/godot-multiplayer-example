extends MultiplayerSynchronizer

@export var direction: Vector2 = Vector2()
@export var running: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	running = Input.is_action_pressed("run")
