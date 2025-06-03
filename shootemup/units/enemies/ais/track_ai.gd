extends AI


func compute(delta, enemy):
	var v = enemy.global_position - GlobalVariables.player.global_position
	var angle = v.angle() - PI/2

	enemy.rotation = lerp_angle(enemy.global_rotation, angle, 2 * delta)
