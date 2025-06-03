extends AI

@export var approach_speed: float = 0.1


func compute(delta, enemy):
	enemy.position = lerp(enemy.global_position, GlobalVariables.player.global_position, approach_speed * delta)
