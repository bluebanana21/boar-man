extends State
class_name VictimViolent


@onready var punching_skeleton: Node3D = $"../../Punching-skeleton"
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"
@onready var animation_tree: AnimationTree = $"../../AnimationTree"

@export var victim:CharacterBody3D

const move_speed: float = 4.0
const attack_range:float = 1.5

var new_velocity := Vector3.ZERO

#Rotates the skeleton model 180 degrees, because if you 
#dont rotate it will face the wrong direction
func Enter():
	punching_skeleton.rotation.y = deg_to_rad(180)
	player = get_node(player_path)


func Update(delta: float):
	pass


func Physics_update(delta: float):
#checks to see if Victim is in attacking range
#will stop movement if in range and start again when out of range
	if victim.global_position.distance_to(player.global_position) < attack_range:
		animation_tree["parameters/conditions/punch"] = 1.0
		await animation_tree.animation_finished
		animation_tree["parameters/conditions/punch"] = 0.0
	else:
#		run the pathfinding algorithim every 3/4 a second
		if Engine.get_physics_frames() % 45 == 0:
			nav_agent.set_target_position(player.global_transform.origin)
			var current_location := victim.global_transform.origin
			var next_location := nav_agent.get_next_path_position()
			var new_velocity := (next_location - current_location).normalized() * move_speed
			
			nav_agent.set_velocity(new_velocity)
		
#		Causes the victim to look towards the player
		victim.look_at(Vector3(player.global_position.x, victim.global_position.y, player.global_position.z), Vector3.UP)
		


#checks to see if victim is in range again 
#in case if player manages to get out of attack range but animation isnt finished
func hit_finished():
	if victim.global_position.distance_to(player.global_position) < attack_range:
		player.hit()
	return


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
# Checks to see if victim is in range or not
# will stop movement code if victim is in attack range
	if !(victim.global_position.distance_to(player.global_position) < attack_range):
		victim.velocity = victim.velocity.move_toward(safe_velocity, 0.25)
		victim.move_and_slide()
	#if the distance between the victim and the player is greater 
	#than the attack range or out of the attack range 
	#then the movement code will continue
	else:
		return
		
