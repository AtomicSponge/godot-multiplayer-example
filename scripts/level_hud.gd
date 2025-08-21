extends CanvasLayer

@onready var BottomLabel: Label = $BottomLabel

func _update_bottom_label(new_text: String) -> void:
	BottomLabel.show()
	BottomLabel.set_text(new_text)
	await get_tree().create_timer(4).timeout
	BottomLabel.hide()

func _ready() -> void:
	EventBus.ShowKill.connect(_update_bottom_label)
