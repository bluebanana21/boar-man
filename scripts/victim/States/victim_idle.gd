extends VictimState
class_name VictimIdle

@export var victim:CharacterBody3D
@export var rotation_speed : float = TAU * 2

@onready var victim_scared_script: VictimScared = $"../VictimScared"
@onready var victim_violent_script: VictimViolent = $"../VictimViolent"

const move_speed: float = 40.0

var _theta : float
var move_direction : Vector3
var wander_time:float
#var active_script:bool = true

#Randomizes the direction which the victim walks towards in Idle State
func randomize_wander():
	#if !active_script:
		#return
	#move_direction = Vector3(randf_range(-1, 1), 0.0, randf_range(-1, 1)).normalized()
	move_direction = Vector3(0.7, 0.0, 0.1).normalized()
	wander_time = randf_range(1,3)

# Called when the node enters the scene tree for the first time.
func Enter():
	#active_script = true
	#if !active_script:
		#return
	randomize_wander()
	


func Update(delta: float):
	#if !active_script:
		#return
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()


func Physics_update(delta: float):
	#if !active_script:
		#return
#checks to see if victim is null or not
	if victim:
		victim.velocity = move_direction * (move_speed * randf_range(0.5 , 1.5)) * delta
	
#checks to see if the move direction variable is null or not
#not null because of randomize wander func
	#if move_direction:
		#_theta = wrapf(atan2(move_direction.x, move_direction.z) - victim.rotation.y, -PI, PI)
		#victim.rotation.y += clamp(rotation_speed * delta, 0, abs(_theta)) * sign(_theta)
	
	victim.move_and_slide()


func _on_victim_health_depleted() -> void:
	#if !active_script:
		#return
	print(victim.name + " transitioned from " + self.name +  " to death state")
	Transitioned.emit(self, "VictimDead")


func _on_state_machine_process_death() -> void:
	#if !active_script:
		#return
	var rand_num = randi_range(0, 100)
	if rand_num < 50:
		Transitioned.emit(self, "VictimScared")
		#print(victim.name, "transition to scared")
	else:
		Transitioned.emit(self, "VictimViolent")
		#print(victim.name, "transition to violent")
	#active_script = false
