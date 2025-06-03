class_name ConfirmDialog extends Window

signal confirmed()
signal canceled()

func _ready():
	$CanvasLayer/VBoxContainer/HBoxContainer/CancelButton.grab_focus()

func _input(event):
	if event.is_action_pressed("confirm"):
		confirm()
	elif event.is_action_pressed("cancel"):
		cancel()

func _on_close_requested():
	close()
	canceled.emit()

func _on_ok_button_pressed():
	confirm()

func _on_cancel_button_pressed():
	cancel()

func open():
	get_tree().paused = true
	$CanvasLayer/VBoxContainer/HBoxContainer/CancelButton.grab_focus()
	visible = true

func close():
	get_tree().paused = false
	visible = false

func confirm():
	close()
	confirmed.emit()

func cancel():
	close()
	canceled.emit()
