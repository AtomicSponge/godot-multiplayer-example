extends Label
## A simple node for displaying the FPS.

## Show the FPS Label.
func show_fps() -> void:
	show()

## Hide the FPS Label.
func hide_fps() -> void:
	hide()

func _process(delta: float) -> void:
	set_text("FPS:  %d" % Engine.get_frames_per_second())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fps") and Input.is_action_just_pressed("fps"):
		if not visible:
			show_fps()
		else:
			hide_fps()
