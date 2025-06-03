extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/TextEdit.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_create_button_pressed():
	Saver.reset_data()
	Saver.data.character_name = $HBoxContainer/TextEdit.text
	Saver.save_data()
	get_tree().change_scene_to_file("res://hq/main.tscn")
