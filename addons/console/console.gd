extends CanvasLayer

@onready var ConsoleContainer: VBoxContainer = $ConsoleContainer
@onready var ConsoleWindow: RichTextLabel = $ConsoleContainer/ConsoleWindow
@onready var ConsoleInput: LineEdit = $ConsoleContainer/ConsoleInput

var _command_table: Dictionary[String, Callable] = {}

## Add text to the console window.
func add_text(new_text: String) -> void:
	if ConsoleWindow == null: return
	ConsoleWindow.add_text(new_text + "\n")

## Set the console window size.
func set_window_size(new_size: Vector2) -> void:
	ConsoleContainer.size.x = new_size.x
	ConsoleWindow.custom_minimum_size.y = new_size.y

## Set the position of the console.
func set_position(new_position: Vector2) -> void:
	ConsoleContainer.position = new_position

## Add a new command to the console
func add_command(command: String, callback: Callable) -> void:
	_command_table[command] = callback

func _process_command(command: String) -> void:
	if not command.begins_with("/"): return
	var cmd_split: Array = command.split(" ", false, 1)
	var cmd = cmd_split[0].lstrip("/")
	var arg = ""
	if cmd_split.size() >= 2:
		arg = cmd_split[1]
	if _command_table.has(cmd):
		_command_table[cmd].call(arg)
	else:
		add_text("Command not found.")

func _on_console_input_text_submitted(new_text: String) -> void:
	ConsoleInput.clear()
	ConsoleInput.has_focus()
	ConsoleInput.call_deferred("edit")
	if new_text == "": return
	_process_command(new_text)

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
