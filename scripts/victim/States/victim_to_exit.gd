extends VictimState  # Replaces KinematicBody with CharacterBody3D
class_name VictimExit


@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"
@onready var punching_skeleton: Node3D = $"../../Punching-skeleton"

@export var victim:CharacterBody3D

const speed: float = 250.0

func Enter():
	pass


func Update(delta: float):
	pass


func Physics_update(delta: float):
	var current_location = victim.global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = ((next_location - current_location) * speed * 2) * delta
	
	victim.look_at(Vector3(next_location.x, victim.global_position.y, next_location.z), Vector3.UP)
	victim.velocity = victim.velocity.move_toward(new_velocity, 0.35)
	victim.move_and_slide()


func update_target_location(target_location):
	nav_agent.target_position = target_location
	#print("target location is being updated")


func _on_victim_health_depleted() -> void:
	#print("transitioned from " + self.name + " to death state")
	Transitioned.emit(self, "VictimDead")


func _on_state_machine_process_death() -> void:
	var rand_num = randi_range(0, 100)
	if rand_num < 50:
		Transitioned.emit(self, "VictimScared")
		#print(victim.name, "transition to scared")
	elif rand_num < 80:
		return
		#print(victim.name, "transition to exit")
	
	else:
		Transitioned.emit(self, "VictimViolent")
		#print(victim.name, "transition to violent")
