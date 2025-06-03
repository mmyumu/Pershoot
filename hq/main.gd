extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/VBoxContainer/RunButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_run_button_pressed():
	get_tree().change_scene_to_file("res://shootemup/main.tscn")

func _on_hangar_button_pressed():
	get_tree().change_scene_to_file("res://hq/hangar.tscn")
