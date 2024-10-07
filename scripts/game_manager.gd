extends Node

@onready var point_counter: Label = $CanvasLayer/PointCounter
@onready var kill_timer: Timer = $KillTimer

var score:int = 0
var kill_ponts:int = 100

#adds point when damaging victim
func add_point():
	score += kill_ponts
	point_counter.text = str(score)
	kill_timer.start()
	
	kill_ponts += 30


func _on_kill_timer_timeout() -> void:
	kill_ponts = 100
