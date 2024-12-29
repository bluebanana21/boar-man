extends State  # Replaces KinematicBody with CharacterBody3D
class_name VictimScared


@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"
@onready var punching_skeleton: Node3D = $"../../Punching-skeleton"

@export var speed: float = 4.5
@export var victim:CharacterBody3D


func Enter():
	punching_skeleton.rotation.y = deg_to_rad(180)


func Update(delta: float):
	pass


func Physics_update(delta: float):
	var current_location = victim.global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location) * speed
	
	victim.look_at(Vector3(next_location.x, victim.global_position.y, next_location.z), Vector3.UP)
	victim.velocity = victim.velocity.move_toward(new_velocity, 0.35)
	victim.move_and_slide()


func update_target_location(target_location):
	nav_agent.target_position = target_location
