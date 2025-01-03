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

func _ready() -> void:
	#count_victim() 
	#victim_current_state()
	kill_streak_counter.visible = false
	report_death_to_victims()


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


func reported_death():
	print("i dont even know anymore")
	report_death_back.emit()

func count_victim():
	victims.clear()  # Clear the array to ensure it's up-to-date
	for victim in victims_node.get_children():
		victims.append(victim)  # Add each child to the victims array
	print("Victims counted:", victims.size())  # Debug: print the number of victims


func victim_current_state() -> void:
	for victim in victims:
		var victim_state_machine = victim.get_node("StateMachine")
		if victim_state_machine.has_method("get_current_state"):  # Check if the victim has a method to get its state
			var state = victim_state_machine.get_current_state()  # Call the method to retrieve the state
			if state == null:
				print("state is null lol")
			else:
				print("Victim State is:", state)   # Debug: Print the state
		elif "state" in victim_state_machine:
			var state = victim_state_machine.current_state        # Access the state property directly
			print("Victim State:", state)   # Debug: Print the state
		else:
			print("Victim does not have a state.")
