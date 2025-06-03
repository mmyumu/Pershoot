extends Behavior

@export_range(0, 10, 0.01) var spawn_period: float = 1
@export var wave_count: int = 3
@export_range(0, 100, 1, "or_greater") var wave_size: int = 3
@export_enum("Random", "Left", "Right", "External", "Internal") var wave_side: String = "External"
@export var instant_spawn: bool		# Spawn starts when behavior is started
@export var x_offset: int = 50
@export var y_offset: int = 50

var spawned_wave_counter = 0

enum WaveSide {
	LEFT,
	RIGHT
}

func _ready():
	super._ready()
	$SpawnTimer.wait_time = spawn_period

func set_polygon(polygon):
	$BoundariesUtil.set_boundaries(polygon)

func start():
	$SpawnTimer.start()
	
	if instant_spawn:
		spawn_wave(wave_size)

func stop():
	$SpawnTimer.stop()

func restart():
	spawned_wave_counter = 0
	start()

func is_over():
	return spawned_wave_counter >= wave_count

func compute_wave_side(wave_spawn_position):
	if wave_side == "Left":
		return WaveSide.LEFT
	elif wave_side == "Right":
		return WaveSide.RIGHT
	elif wave_side == "Random":
		return WaveSide.LEFT if randi() % 2 == 0 else WaveSide.RIGHT
	elif wave_side == "External":
		return WaveSide.RIGHT if wave_spawn_position.x >= ($BoundariesUtil.max_point.x / 2) else WaveSide.LEFT
	elif wave_side == "Internal":
		return WaveSide.LEFT if wave_spawn_position.x >= ($BoundariesUtil.max_point.x / 2) else WaveSide.RIGHT

func spawn_wave(number_of_enemies):
	var spawned_enemies = []
	#var left_side: bool
	var current_x_offset: int = x_offset
	var wave_spawn_position = $BoundariesUtil.get_random_position()
	
	var current_wave_side = compute_wave_side(wave_spawn_position)
	if current_wave_side == WaveSide.LEFT:
		current_x_offset *= -1

	for i in range(number_of_enemies):
		if i > 0:
			await get_tree().create_timer(0.1).timeout

		var spawn_position = Vector2(wave_spawn_position.x + (current_x_offset * i), wave_spawn_position.y - (y_offset * i))
		spawn_triggered.emit(spawn_position)

	spawned_wave_counter += 1
	
	if wave_count > 0 and is_over():
		stop()

	return spawned_enemies


func _on_spawn_timer_timeout():
	spawn_wave(wave_size)
