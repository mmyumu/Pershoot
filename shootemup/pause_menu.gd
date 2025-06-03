extends CanvasLayer


func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass
	
func _shortcut_input(_event):
	if Input.is_action_pressed("pause"):
		var is_paused = get_tree().paused
		get_tree().paused = !is_paused

		if is_paused:
			$PauseMessage/PauseLabel.hide()
			$PauseMessage/ResumeLabel.hide()
		else:
			$PauseMessage/PauseLabel.show()
			$PauseMessage/ResumeLabel.show()
