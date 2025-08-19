extends CanvasLayer

@onready var ConsoleContainer: VBoxContainer = $ConsoleContainer
@onready var ConsoleWindow: RichTextLabel = $ConsoleContainer/ConsoleWindow
@onready var ConsoleInput: LineEdit = $ConsoleContainer/ConsoleInput

func add_text(new_text: String) -> void:
	ConsoleWindow.add_text(new_text)

func set_window_size(new_size: Vector2) -> void:
	ConsoleContainer.size.x = new_size.x
	ConsoleWindow.custom_minimum_size.y = new_size.y

func set_position(new_position: Vector2) -> void:
	ConsoleContainer.position = new_position

func _on_console_input_text_submitted(new_text: String) -> void:
	ConsoleInput.clear()
	ConsoleInput.has_focus()
	ConsoleInput.call_deferred("edit")
	if new_text == "": return
	ConsoleWindow.add_text(new_text + "\n")

func _on_console_input_text_changed(_new_text: String) -> void:
	if visible and Input.is_action_just_pressed("console"):
		ConsoleInput.clear()
		hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("console") and Input.is_action_just_pressed("console"):
		if not visible:
			show()
			ConsoleInput.has_focus()
			ConsoleInput.call_deferred("edit")
		else:
			hide()

func _ready() -> void:
	hide()
