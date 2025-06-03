class_name Weapon extends Node2D

@export var projectile: PackedScene

signal shoot(projectile, direction, location)

func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass
