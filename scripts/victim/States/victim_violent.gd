extends State
class_name VictimViolent


@onready var punching_skeleton: Node3D = $"../../Punching-skeleton"
@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"
@onready var animation_tree: AnimationTree = $"../../AnimationTree"

@export var victim:CharacterBody3D
@export var move_speed: float = 15.0
@export var rotation_speed : float = TAU * 2
const attack_range:float = 1.5

# Called when the node enters the scene tree for the first time.
func Enter():
	punching_skeleton.rotation.y = deg_to_rad(180)
	player = get_node(player_path)


func Update(delta: float):
	pass
	


func Physics_update(delta: float):
	if victim.global_position.distance_to(player.global_position) < attack_range:
		animation_tree["parameters/conditions/punch"] = 1.0
		await animation_tree.animation_finished
		animation_tree["parameters/conditions/punch"] = 0.0
	else:
		victim.velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		victim.velocity = (next_nav_point - victim.global_transform.origin).normalized() * move_speed
		
		victim.look_at(Vector3(player.global_position.x, victim.global_position.y, player.global_position.z), Vector3.UP)
	
		victim.move_and_slide()


func hit_finished():
	player.hit()


#func _on_navigation_agent_3d_target_reached() -> void:
	#animation_tree["parameters/conditions/punch"] = 1.0
	#move_speed = 0
	##player.hit()
	#
	#await animation_tree.animation_finished
	#animation_tree["parameters/conditions/punch"] = 0.0
