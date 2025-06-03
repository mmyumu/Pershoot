class_name SteppedScenario extends Scenario

var step: float = -1

func start():
	set_step(0)

func set_step(step_number):
	step = step_number
	print("Scenario: %s -> set step to %s" % [name, step])
