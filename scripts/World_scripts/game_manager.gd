extends Node

@onready var point_counter: Label = $CanvasLayer/PointCounter
@onready var kill_streak_counter: Label = $CanvasLayer/KillStreakCounter
@onready var fps_counter: Label = $CanvasLayer/FPSCounter
@onready var kill_timer: Timer = $KillTimer

var score:int = 0
var kill_ponts:int = 100
var kill_streak:int = 0

func _ready() -> void:
	kill_streak_counter.visible = false


func _process(delta: float) -> void:
	var fps:float = Engine.get_frames_per_second()
	fps_counter.text = str(fps)

#adds point when damaging victim
func add_point():
	score += kill_ponts
	point_counter.text = str(score)
	kill_streak_counter.visible = true
	kill_streak += 1
	kill_streak_counter.text = str(kill_streak) + "X"
	kill_timer.start()
	
	kill_ponts += 30

func _on_kill_timer_timeout() -> void:
	kill_streak = 0
	kill_streak_counter.visible = false
	kill_ponts = 100
