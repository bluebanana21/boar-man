extends Node

signal deathReported

@onready var game_manager: Node = $"../../../../GameManager"
@onready var victim: Victim = $".."

@export var initial_state : VictimState

var current_state : VictimState
var states:Dictionary = {}
var state_report : String


func _ready() -> void:
	for child in get_children():
		if child is VictimState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
		state_report = initial_state.name
	
	listen_to_victim_death()


func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
		#print("current state is ",current_state)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_update(delta)
	


func on_child_transition(state, new_state_name)->void:
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
	state_report = current_state.name
	
	report_death()
	print("state report: ", state_report)


func report_death():
	if state_report == "VictimDead":
		print("death reported")
		deathReported.emit()
	else:
		pass


func get_current_state():
	#print("state report: ", state_report)
	return state_report


func listen_to_victim_death():
	game_manager.report_death_back.connect(process_death)
	print(victim, " is processing death")


func process_death():
	
	if current_state is VictimIdle:
		print(victim, " should run away now") 
