extends Node2D

var input_type = "joypad"

var screen_size: Vector2
var player


func _ready():
	screen_size = get_viewport_rect().size
