extends CanvasLayer

@onready var BottomLabel: Label = $BottomLabel
@onready var ScorePanel: Panel = $ScorePanel

func _update_bottom_label(new_text: String) -> void:
	BottomLabel.show()
	BottomLabel.set_text(new_text)
	await get_tree().create_timer(4).timeout
	BottomLabel.hide()

func _ready() -> void:
	EventBus.ShowKill.connect(_update_bottom_label)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("score_panel") and Input.is_action_just_pressed("score_panel"):
		if ScorePanel.visible:
			ScorePanel.hide()
		else:
			ScorePanel.show()
