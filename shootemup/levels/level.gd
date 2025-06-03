class_name Level extends Node2D

var scenario: Scenario

signal enemy_spawned(enemy)

func _ready():
	pass

func _on_enemy_spawned(enemy):
	enemy_spawned.emit(enemy)

func set_scenario(scenario_to_be_set: Scenario):
	if scenario:
		remove_child(scenario)
		scenario.queue_free()

	scenario = scenario_to_be_set
	add_child(scenario)
	scenario.enemy_spawned.connect(_on_enemy_spawned)

func start():
	scenario.start()

func stop():
	scenario.stop()
