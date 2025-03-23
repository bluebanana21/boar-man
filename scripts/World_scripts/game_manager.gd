extends Node

signal report_death_back

@onready var point_counter: Label = $CanvasLayer/PointCounter
@onready var kill_streak_counter: Label = $CanvasLayer/KillStreakCounter
@onready var fps_counter: Label = $CanvasLayer/FPSCounter
@onready var kill_timer: Timer = $KillTimer
@onready var exit_location: Node3D = $"../../exitLocation"
@onready var victims_node: Node3D = $"../SubViewport/Victims"

var score:int = 0
var kill_ponts:int = 100
var kill_streak:int = 0
var victims:Array = []
var current_victim_states : Array = []
var num_of_violent: int = 0

func _ready() -> void:
	#count_victim() 
	#victim_current_state()
	kill_streak_counter.visible = false
	report_death_to_victims()
	
	for victim in victims_node.get_children():
		var victim_state_machine = victim.get_node("StateMachine")
		victim_state_machine.statusReport.connect(process_victim_state)
		var victim_volent_state_node = victim_state_machine.get_node("VictimViolent")
		victim_volent_state_node.entered_violent.connect(increase_violent_num)
		victim_volent_state_node.exited_violent.connect(decrease_violent_num)


func state_machine_processes():
	pass


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
	pass


func report_death_to_victims():
	for victim in victims_node.get_children():
		var victim_state_machine = victim.get_node("StateMachine")
		victim_state_machine.deathReported.connect(reported_death)

#Func is called every time a victim is killed and reorts the death back to the victims
func reported_death():
	print("i dont even know anymore")
	report_death_back.emit()


func count_victim():
	victims.clear()  # Clear the array to ensure it's up-to-date
	for victim in victims_node.get_children():
		victims.append(victim)  # Add each child to the victims array
	print("Victims counted:", victims.size())  # Debug: print the number of victims


func process_victim_state(state_report):
	print("processing the state of victim")
	if state_report == "VictimToExit":
		#print("victim to exit state")
		get_tree().call_group("enemies", "update_target_location", exit_location.global_transform.origin)


func increase_violent_num():
	num_of_violent += 1
	print("number of violent victims: ", num_of_violent)


func decrease_violent_num():
	if num_of_violent <= 0:
		return
	num_of_violent -= 1
	print("number of violent victims: ", num_of_violent)
