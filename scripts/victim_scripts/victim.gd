extends CharacterBody3D

class_name victim

@onready var victim_label: Label3D = $VictimLabel
@onready var label_timer: Timer = $VictimLabel/LabelTimer
@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $VictimLabel/AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var fov_cast: RayCast3D = $FOVCast

@onready var nav_region: NavigationRegion3D = $"../Map/NavRegion"

@export var turn_speed:int = 180
@export var walk_speed: float = 2.0
@export var run_speed: float = 5.0


enum {
	IDLE, 
	RUN,
	ATTACK
}

var random_position := Vector3.ZERO
var victim_state = IDLE
var has_seen:bool = false
var can_move = false

func _ready() -> void:
	victim_label.visible = false

func _physics_process(delta: float) -> void:
	var move_dir = 0
	var turn_dir = random_position.z
	
	match victim_state:
		IDLE:
			idle()
		RUN:
			pass
		ATTACK:
			pass
	
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	rotation_degrees.y += turn_dir * turn_speed * delta
	velocity = direction * global_transform.basis.z * walk_speed 
	
	
	move_and_slide()


func damage() -> void:
	victim_label.visible = true
	victim_label.text = str(game_manager.kill_ponts)
	animation_player.play("appear")
	game_manager.add_point()
	print("victim dead")
	
	await animation_player.animation_finished
	victim_label.visible = false


func idle() -> void:
	print("hll")
	await get_tree().create_timer(1.5).timeout
	
	random_position.x = randf_range(-5.0, 5.0)
	random_position.z = randf_range(-5.0, 5.0)
	navigation_agent_3d.set_target_position(random_position)
	
	


func run() -> void:
	pass


func attack() -> void:
	pass
