extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	alert("test")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func alert(text: String) -> void:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	dialog.dialog_hide_on_ok = false # Disable default behaviour
	dialog.connect('confirmed', dialog.queue_free) # Free node on OK
	var scene_tree = Engine.get_main_loop()
	scene_tree.current_scene.add_child(dialog)
	dialog.popup_centered()
