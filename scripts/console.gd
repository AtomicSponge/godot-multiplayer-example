extends CanvasLayer

@onready var ConsoleWindow: RichTextLabel = $ConsoleWindow
@onready var ConsoleInput: LineEdit = $ConsoleInput

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("console") and Input.is_action_just_pressed("console"):
		if not visible:
			show()
		else:
			hide()
