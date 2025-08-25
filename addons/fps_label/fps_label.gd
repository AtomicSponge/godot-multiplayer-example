extends Label
## A simple node for displaying the FPS.
## Also includes a powermode that shows process time

var power_mode: bool = false

## Show the FPS Label.
func show_fps() -> void:
	power_mode = false
	show()

## Show the FPS Label in powermode.
func show_powermode() -> void:
	power_mode = true
	show()

## Hide the FPS Label.
func hide_fps() -> void:
	hide()

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if power_mode:
		set_text("FPS:  %d" % Engine.get_frames_per_second() +
			"\nCPU:  %f" % delta)
	else:
		set_text("FPS:  %d" % Engine.get_frames_per_second())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fps") and Input.is_action_just_pressed("fps"):
		if not visible:
			show_fps()
		else:
			if not power_mode:
				power_mode = true
			else:
				power_mode = false
				hide_fps()
