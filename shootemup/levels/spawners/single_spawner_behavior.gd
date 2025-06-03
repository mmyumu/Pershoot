extends Behavior

@export_range(0, 10, 0.01) var spawn_period: float = 1
@export_range(0, 20, 1, "or_greater") var spawn_count: int = 3

var spawned_counter = 0


func _ready():
	super._ready()
	$SpawnTimer.wait_time = spawn_period

func set_polygon(polygon):
	$BoundariesUtil.set_boundaries(polygon)

func start():
	super.start()
	$SpawnTimer.start()

func stop():
	super.stop()
	$SpawnTimer.stop()

func restart():
	spawned_counter = 0
	start()

func is_over():
	return spawned_counter >= spawn_count

func _on_spawn_timer_timeout():
	var spawn_position = $BoundariesUtil.get_random_position()
	spawn_triggered.emit(spawn_position)
	spawned_counter += 1
	
	if spawn_count > 0 and is_over():
		stop()
	
