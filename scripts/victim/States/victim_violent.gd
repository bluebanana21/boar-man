extends VictimState
class_name VictimViolent

signal entered_violent
signal exited_violent

@onready var punching_skeleton: Node3D = $"../../Punching-skeleton"
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"
@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var model_animation: AnimationPlayer = $"../../Punching-skeleton/ModelAnimation"

@export var victim:CharacterBody3D

const rotation_speed : float = TAU * 300
const attack_range:float = 1.5

var move_speed: float = 550.0
var _theta : float
var active_script: bool = false

#Rotates the skeleton model 180 degrees, because if you 
#dont rotate it will face the wrong direction
func Enter():
	active_script = true
	if !active_script:
		return
	print(victim.name, " transition to violent state ahhhhhhhhhhh")
	entered_violent.emit()


func Update(delta: float):
	pass


func Physics_update(delta: float):
	if !active_script:
		return
#checks to see if Victim is in attacking range
#will stop movement if in range and start again when out of range
	if victim.global_position.distance_to(player.global_position) < attack_range:
		animation_tree["parameters/conditions/punch"] = 1.0
		await animation_tree.animation_finished
		animation_tree["parameters/conditions/punch"] = 0.0
	else:
#		run the pathfinding algorithim every 3/4 a second
		if Engine.get_physics_frames() % (randi_range(20, 30)) == 0:
			nav_agent.set_target_position(player.global_transform.origin)
			var current_location := victim.global_transform.origin
			var next_location := nav_agent.get_next_path_position()
			var new_velocity := (next_location - current_location).normalized() * move_speed * delta
			
			nav_agent.set_velocity(new_velocity)
			


#checks to see if victim is in range again 
#in case if player manages to get out of attack range but animation isnt finished
func hit_finished():
	if !active_script:
		return
	if victim.global_position.distance_to(player.global_position) < attack_range:
		player.hit()
		
	return


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	if !active_script:
		return
	var delta := victim.get_process_delta_time()
# Checks to see if victim is in range or not
# will stop movement code if victim is in attack range
	if !(victim.global_position.distance_to(player.global_position) < attack_range):
		victim.velocity = victim.velocity.move_toward(safe_velocity, 0.25)
		
	#	Causes the victim to look towards the player
		_theta = wrapf(atan2(victim.velocity.x, victim.velocity.z) - victim.rotation.y, -PI, PI)
		victim.rotation.y += clamp((rotation_speed * delta) * 10, 0, abs(_theta)) * sign(_theta)
		
		victim.move_and_slide()
	#if the distance between the victim and the player is greater 
	#than the attack range or out of the attack range 
	#then the movement code will continue
	else:
		return
		


func _on_victim_health_depleted() -> void:
	if !active_script:
		return
	nav_agent.set_velocity(Vector3.ZERO)
	print(victim.name + " transitioned from " + self.name +  " to death state")
	exited_violent.emit()
	Transitioned.emit(self, "VictimDead")

#
#func _on_state_machine_process_death() -> void:
	#var rand_num = randi_range(0, 100)
	#if rand_num < 50:
		#Transitioned.emit(self, "VictimScared")
		##exited_violent.emit()
		#print("being processed in violent state")
		##print(victim.name, "transition to scared")
	#else:
		#return
		##print(victim.name, "transition to violent")
