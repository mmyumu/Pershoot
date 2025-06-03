extends Node

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Saver.save_data()
		get_tree().quit() # default behavior
