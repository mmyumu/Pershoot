class_name MainStage extends Node

@export var scenario_scenes: Array[PackedScene]
@export var background_textures: Array[Texture]

var current_enemies = []


func _ready():
	GlobalVariables.player = $Player
	get_tree().paused = true
	update_hud_hp()
	update_hud_money()
	$Player.hide()
	
	var background_texture: Texture = background_textures[randi() % background_textures.size()]
	$Level/Background.set_texture(background_texture)
	
	# TODO: get scenario from global infos/attack
	var scenario_scene: PackedScene = preload("res://shootemup/levels/scenarios/scenario_debug.tscn")
	var scenario = scenario_scene.instantiate()
	$Level.set_scenario(scenario)
	
	scenario.scenario_completed.connect(stage_completed)

func _process(_delta):
	pass

func _on_player_shoot(projectile, direction, location):
	var spawned_projectile = projectile.instantiate()
	add_child(spawned_projectile)
	spawned_projectile.add_to_group("Player")
	spawned_projectile.get_node("ProjectileShape").color = Color(0, 0, 255, 0.5)
	spawned_projectile.rotation = direction
	spawned_projectile.position = location
	spawned_projectile.velocity = spawned_projectile.velocity.rotated(direction)

func update_hud_hp():
	if $Player:
		$HUD/HP/HPLabel.text = str(max($Player.hp, 0))
		$HUD/HP/MaxHPLabel.text = str($Player.max_hp)

func update_hud_money():
	if $Player:
		$HUD/Money.text = "%s $" % str($Player.money)

func _on_hud_start_play():
	start_stop_game(true)
	
func _on_enemy_shoot(projectile, direction, location):
	var spawned_projectile = projectile.instantiate()
	add_child(spawned_projectile)
	spawned_projectile.add_to_group("Enemies")
	spawned_projectile.get_node("ProjectileShape").color = Color(255, 0, 0, 0.5)
	spawned_projectile.rotation = direction
	spawned_projectile.position = location
	spawned_projectile.velocity = spawned_projectile.velocity.rotated(direction)

func _on_enemy_destroyed(enemy):
	GlobalVariables.player.money += enemy.money
	update_hud_money()

func _on_player_game_over():
	start_stop_game(false)
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://hq/main.tscn")

func start_stop_game(start: bool, _game_over:bool = true):
	if start:
		$Player.show()
		$Level.start()
		$HUD/GameOverLabel.hide()
		get_tree().paused = false
	else:
		$Level.stop()
		$Player.hide()
		$HUD/GameOverLabel.show()
		get_tree().paused = true
#
func _on_player_hit(_damage):
	update_hud_hp()

func _on_enemy_spawned(enemy):
	current_enemies.append(enemy)
	add_child(enemy)
	enemy.shoot.connect(_on_enemy_shoot)
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)

func get_spawned_enemies():
	var spawned_enemies = []
	for current_enemy in current_enemies:
		if is_instance_valid(current_enemy):
			spawned_enemies.append(current_enemy)

	return spawned_enemies

func stage_completed():
	$HUD/StageCompletedLabel.show()
	$Player.invulnerable = true
	
	#Global.current_attack.status = Attack.Status.OVER

	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://hq/main.tscn")
