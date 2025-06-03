extends CanvasLayer


func _ready():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$VBoxContainer/StartButton.grab_focus()
	
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://game_slots/main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_continue_button_pressed():
	Saver.load_data()
	get_tree().change_scene_to_file("res://global/main.tscn")
