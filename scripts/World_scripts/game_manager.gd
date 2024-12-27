extends Node

@onready var point_counter: Label = $CanvasLayer/PointCounter
@onready var kill_streak_counter: Label = $CanvasLayer/KillStreakCounter
@onready var fps_counter: Label = $CanvasLayer/FPSCounter
@onready var kill_timer: Timer = $KillTimer
@onready var exit_location: Node3D = $"../../exitLocation"
@onready var victims: Node3D = $"../SubViewport/Victims"

var score:int = 0
var kill_ponts:int = 100
var kill_streak:int = 0


func _ready() -> void:
	kill_streak_counter.visible = false


func _process(delta: float) -> void:
	var fps:float = Engine.get_frames_per_second()
	fps_counter.text = str(fps)

#adds point when damaging victim 
#adds 30 units to kill points variable for every consecutive kill
func add_point():
	score += kill_ponts
	point_counter.text = str(score)
	kill_streak_counter.visible = true
	kill_streak += 1
	kill_streak_counter.text = str(kill_streak) + "X"
	kill_timer.start()
	
	kill_ponts += 30


#resets the Kill streak and reverts the kill points back to 100
func _on_kill_timer_timeout() -> void:
	kill_streak = 0
	kill_streak_counter.visible = false
	kill_ponts = 100


func _physics_process(delta: float) -> void:
	get_tree().call_group("enemies", "update_target_location", exit_location.global_transform.origin)
