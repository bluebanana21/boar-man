extends State
class_name VictimViolent


@onready var punching_skeleton: Node3D = $"../../Punching-skeleton"
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"
@onready var animation_tree: AnimationTree = $"../../AnimationTree"

@export var victim:CharacterBody3D

const move_speed: float = 5.0
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
		if Engine.get_physics_frames() % 30 == 0:
			victim.velocity = Vector3.ZERO
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point := nav_agent.get_next_path_position()
			var new_velocity := (next_nav_point - victim.global_transform.origin).normalized() * move_speed
			victim.velocity = new_velocity
			print(new_velocity)
		
		victim.look_at(Vector3(player.global_position.x, victim.global_position.y, player.global_position.z), Vector3.UP)
		
		victim.move_and_slide()


#checks to see if victim is in range again 
#in case if player manages to get out of attack range but animation isnt finished
func hit_finished():
	if victim.global_position.distance_to(player.global_position) < attack_range:
		player.hit()
	return
