extends CanvasLayer

@onready var Console: CanvasLayer = $Console

################################################################################
#   Console commands														   #
################################################################################
##  Broadcast a message to chat
func say_command(text: String) -> void:
	var sent: bool = Steam.sendLobbyChatMsg(Globals.LOBBY_ID, text)
	if not sent:
		Console.add_text("Your message was not sent!")
	elif Globals.LOBBY_ID == 0:
		Console.add_text("You are not in a lobby!")

##  Quit the game from command
func quit_command(_arg: String) -> void:
	Globals.quit_game()
################################################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Console.set_console_size(Vector2(550, 200))
	Console.set_position(Vector2(2, 482))
	Console.add_command("say", say_command)
	Console.add_command("quit", quit_command)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
