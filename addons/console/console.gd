extends CanvasLayer

@onready var ConsoleContainer: VBoxContainer = $ConsoleContainer
@onready var ConsoleWindow: RichTextLabel = $ConsoleContainer/ConsoleWindow
@onready var ConsoleInput: LineEdit = $ConsoleContainer/ConsoleInput
@onready var FaderA: AnimationPlayer = $ConsoleContainer/ConsoleWindow/FaderA
@onready var FaderB: AnimationPlayer = $ConsoleContainer/ConsoleInput/FaderB

var _command_table: Dictionary[StringName, Callable] = {}

## Add text to the console window.  Automatically appends a new line.
## If called when the console is not visible it will display for a few seconds.
func add_text(new_text: String, seconds: float = 4.0) -> void:
	if ConsoleWindow == null: return
	ConsoleWindow.add_text(new_text + "\n")
	show_output(seconds)

## Set the console size.  This does not include the LineEdit height.  That is adjusted by the font size.
func set_console_size(new_size: Vector2) -> void:
	ConsoleContainer.size.x = new_size.x
	ConsoleWindow.custom_minimum_size.y = new_size.y

## Set the position of the console.
func set_position(new_position: Vector2) -> void:
	ConsoleContainer.position = new_position

## Set the font size.  Applies to both the window and the input field.
func set_font_size(new_size: int) -> void:
	ConsoleWindow.add_theme_font_size_override("bold_italics_font_size", new_size)
	ConsoleWindow.add_theme_font_size_override("italics_font_size", new_size)
	ConsoleWindow.add_theme_font_size_override("mono_font_size", new_size)
	ConsoleWindow.add_theme_font_size_override("normal_font_size", new_size)
	ConsoleWindow.add_theme_font_size_override("bold_font_size", new_size)
	ConsoleInput.add_theme_font_size_override("font_size", new_size)

## Sets the background color for the console window.
func set_window_bg_color(new_color: Color) -> void:
	var theme = Theme.new()
	var style_box = StyleBoxFlat.new()
	style_box.set_bg_color(new_color)
	theme.set_stylebox("normal", "RichTextLabel", style_box)
	ConsoleWindow.theme = theme

## Sets the background color for the input text box.
func set_input_bg_color(new_color: Color) -> void:
	var theme = Theme.new()
	var style_box = StyleBoxFlat.new()
	style_box.set_bg_color(new_color)
	theme.set_stylebox("normal", "LineEdit", style_box)
	ConsoleInput.theme = theme

## Adds a new command to the console.
## The callback must accept a single string as the argument.
func add_command(command: StringName, callback: Callable) -> void:
	_command_table[command] = callback

## Check if the console is opened.
func is_opened() -> bool:
	return visible

## Show the console window for a few seconds.
func show_output(seconds: float = 4.0) -> void:
	if not visible:
		_show_console(false)
		ConsoleInput.hide()
		await get_tree().create_timer(seconds).timeout
		if visible:
			_hide_console(false)

func _process_command(command: String) -> void:
	if not command.begins_with("/"): return
	var cmd_split: Array = command.split(" ", false, 1)
	var cmd: StringName = cmd_split[0].lstrip("/")
	var arg: String = ""
	if cmd_split.size() >= 2:
		arg = cmd_split[1]
	if _command_table.has(cmd):
		_command_table[cmd].call(arg)
	else:
		add_text(cmd + ":  Command not found.")

func _on_console_input_text_submitted(new_text: String) -> void:
	ConsoleInput.clear()
	ConsoleInput.has_focus()
	ConsoleInput.call_deferred("edit")
	if new_text == "": return
	_process_command(new_text)

func _on_console_input_text_changed(_new_text: String) -> void:
	if visible and Input.is_action_pressed("console"):
		ConsoleInput.clear()
		_hide_console()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("console") and Input.is_action_just_pressed("console"):
		if not visible:
			_show_console()
			ConsoleInput.show()
			ConsoleInput.has_focus()
			ConsoleInput.call_deferred("edit")
		else:
			ConsoleInput.clear()
			_hide_console()

func _show_console(play_b: bool = true) -> void:
	show()
	FaderA.play("Fade")
	if play_b: FaderB.play("Fade")
	await FaderA.animation_finished

func _hide_console(play_b: bool = true) -> void:
	FaderA.play_backwards("Fade")
	if play_b: FaderB.play_backwards("Fade")
	await FaderA.animation_finished
	hide()

func _ready() -> void:
	set_window_bg_color(Color(0.0, 0.0, 0.0, 0.2))
	hide()
