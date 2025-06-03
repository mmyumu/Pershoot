extends Weapon

func _ready():
	pass # Replace with function body.

func _process(_delta):
	pass

func _on_shoot_timer_timeout():
	shoot.emit(projectile, global_rotation, global_position)
	await get_tree().create_timer(0.2).timeout
	shoot.emit(projectile, global_rotation, global_position)
	await get_tree().create_timer(0.2).timeout
	shoot.emit(projectile, global_rotation, global_position)

func _on_visible_on_screen_notifier_2d_screen_entered():
	$ShootTimer.start()
