class_name GameSlot extends HBoxContainer

var slot_number: int
var data: Data

func set_slot_number(slot_number_to_set):
	slot_number = slot_number_to_set

func _ready():
	build_game_slot()

func build_game_slot():
	data = Saver.get_data(slot_number)
	if data:
		$EmptySlot.visible = false
		$Slot.visible = true
		$CenterContainer/Erase.disabled = false
		
		$Slot/MarginContainer/VBoxContainer/Name.text = data.get_data_name()
		
		var datetime: Datetime = data.last_saved
		$Slot/MarginContainer/VBoxContainer/Date.text = datetime.get_datetime_str()
	else:
		$EmptySlot.visible = true
		$Slot.visible = false
		$CenterContainer/Erase.disabled = true

func set_focus():
	if data:
		$Slot.grab_focus()
	else:
		$EmptySlot.grab_focus()

func _on_erase_pressed():
	$ConfirmDialog.open()

func _on_empty_slot_pressed():
	Saver.set_slot(slot_number)
	#Saver.reset_data()
	#Saver.save_data()
	build_game_slot()
	# get_tree().change_scene_to_file("res://new_character/main.tscn")
	Saver.reset_data()
	# Saver.data.character_name = $HBoxContainer/TextEdit.text
	Saver.save_data()
	get_tree().change_scene_to_file("res://hq/main.tscn")

func _on_slot_pressed():
	Saver.set_slot(slot_number)
	Saver.load_data()
	build_game_slot()
	get_tree().change_scene_to_file("res://hq/main.tscn")


func _on_confirm_dialog_confirmed():
	$ConfirmDialog.close()
	Saver.erase_data(slot_number)
	data = null
	build_game_slot()

func _on_confirm_dialog_canceled():
	$ConfirmDialog.close()
