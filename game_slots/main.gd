@tool
extends Node

var game_slot_scene: PackedScene = preload("res://game_slots/game_slot.tscn")

func _ready():
	for i in  Saver.get_number_of_slots():
		var game_slot: GameSlot = game_slot_scene.instantiate()
		game_slot.set_slot_number(i)
		
		$VBoxContainer/GameSlotsContainer.add_child(game_slot)
		if i == 0:
			game_slot.set_focus()

func _input(event):
	if event.is_action_pressed("cancel"):
		_on_back_button_pressed()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
