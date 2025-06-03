extends CanvasLayer

signal start_play


func _ready():
	$StartPlay/StartTimer.start()

func _process(_delta):
	update_start_play()

func update_start_play():
	if $StartPlay/StartTimer.time_left < 1: 
		$StartPlay/StartLabel.text = "Go !"
	else:
		$StartPlay/StartLabel.text = str(int($StartPlay/StartTimer.time_left))


func _on_start_timer_timeout():
	$StartPlay/StartLabel.hide()
	start_play.emit()
