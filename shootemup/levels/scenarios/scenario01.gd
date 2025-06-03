extends SteppedScenario

func _ready():
	super._ready()

func _process(delta):
	super._process(delta)
	
	if step == 0:
		$FighterSpawnerLeft.start()
		$FighterSpawnerRight.start()
		set_step(0.5)
	elif step == 0.5:
		if $FighterSpawnerLeft.is_depleted() and $FighterSpawnerRight.is_depleted():
			set_step(1)
	elif step == 1:
		$FighterSpawnerTop.start()
		set_step(1.5)
	elif step == 1.5:
		if $FighterSpawnerTop.is_depleted():
			set_step(2)
	elif step == 2:
		$FighterSpawnerLeft.restart()
		$FighterSpawnerRight.restart()
		$FighterSpawnerTop.restart()
		set_step(2.5)
	elif step == 2.5:
		if $FighterSpawnerTop.is_depleted() and $FighterSpawnerLeft.is_depleted() and $FighterSpawnerRight.is_depleted():
			scenario_completed.emit()
