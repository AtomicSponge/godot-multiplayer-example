extends CanvasLayer

@onready var BottomLabel: Label = $BottomLabel
@onready var ScorePanel: Panel = $ScorePanel

@onready var ScorePanelPlayerRef: Array[Label] = [
	$ScorePanel/Player1, $ScorePanel/Player2, $ScorePanel/Player3, $ScorePanel/Player4,
	$ScorePanel/Player5, $ScorePanel/Player6, $ScorePanel/Player7, $ScorePanel/Player8,
	$ScorePanel/Player9, $ScorePanel/Player10, $ScorePanel/Player11, $ScorePanel/Player12,
	$ScorePanel/Player13, $ScorePanel/Player14, $ScorePanel/Player15, $ScorePanel/Player16,
]

func _update_bottom_label(new_text: String) -> void:
	BottomLabel.show()
	BottomLabel.set_text(new_text)
	await get_tree().create_timer(4).timeout
	BottomLabel.hide()

func _ready() -> void:
	EventBus.ShowKill.connect(_update_bottom_label)

	for element in ScorePanelPlayerRef:
		element.text = ""

func _process(_delta: float) -> void:
	for counter in Globals.LOBBY_MEMBERS.size():
		ScorePanelPlayerRef[counter].text = Globals.LOBBY_MEMBERS[counter].steam_name

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("score_panel") and Input.is_action_just_pressed("score_panel"):
		if ScorePanel.visible:
			ScorePanel.hide()
		else:
			ScorePanel.show()
