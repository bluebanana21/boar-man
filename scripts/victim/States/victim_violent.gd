extends State
class_name VictimViolent

var player = null 

@onready var nav_agent: NavigationAgent3D = $"../../NavigationAgent3D"

@export var victim:CharacterBody3D
@export var player_path:NodePath = "/root/World/SubViewportContainer/SubViewport/PlayerFPS"
@export var move_speed: float = 15.0
@export var rotation_speed : float = TAU * 2

var _theta : float
#var move_direction : Vector3
#var wander_time:float


func go_towards_player():
	pass
	#move_direction = Vector3(randf_range(-1, 1), 0.0, randf_range(-1, 1)).normalized()
	#wander_time = randf_range(1,3)
	

# Called when the node enters the scene tree for the first time.
func Enter():
	player = get_node(player_path)


func Update(delta: float):
	pass
	


func Physics_update(delta: float):
	victim.velocity = Vector3.ZERO	
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	victim.velocity = (next_nav_point - victim.global_transform.origin).normalized() * move_speed
	
	victim.look_at(Vector3(player.global_position.x, victim.global_position.y, player.global_position.z), Vector3.UP)
	
	victim.move_and_slide()
