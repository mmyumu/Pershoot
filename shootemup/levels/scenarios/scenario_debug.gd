extends SteppedScenario

func _ready():
	super._ready()

func _process(delta):
	super._process(delta)
	
	if step == 0:
		$FighterSpawnerRight.start()
		set_step(0.5)
	elif step == 0.5:
		if $FighterSpawnerRight.is_depleted():
			scenario_completed.emit()
