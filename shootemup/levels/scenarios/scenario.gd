class_name Scenario extends Node2D

var spawners: Array[Spawner] = []

signal enemy_spawned(enemy)
signal scenario_completed()

func _ready():
	for node in get_children():
		if node is Spawner:
			spawners.append(node)
			node.enemy_spawned.connect(_on_enemy_spawned)

func _process(_delta):
	pass

func _on_enemy_spawned(enemy):
	enemy_spawned.emit(enemy)

func start():
	pass

func stop():
	pass
