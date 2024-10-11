extends CharacterBody3D

@onready var victim_label: Label3D = $VictimLabel
@onready var label_timer: Timer = $VictimLabel/LabelTimer
@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $VictimLabel/AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var fov_cast: RayCast3D = $FOVCast

@onready var get_nav_map: NavigationAgent3D = get_parent().get_node("SubViewportContainer/SubViewport/Map/NavigationRegion3D")

@export var walk_speed: float = 2.0
@export var run_speed: float = 5.0

var all_points = []
var next_point:int = 0

enum {
	IDLE, 
	RUN,
	ATTACK
}

var victim_state = IDLE
var has_seen = false

func _ready() -> void:
	victim_label.visible = false

func _physics_process(delta: float) -> void:
	
	
	match victim_state:
		IDLE:
			pass
		RUN:
			pass
		ATTACK:
			pass


func damage() -> void:
	victim_label.visible = true
	victim_label.text = str(game_manager.kill_ponts)
	animation_player.play("appear")
	game_manager.add_point()
	print("victim dead")
	
	await animation_player.animation_finished
	victim_label.visible = false


func idle() -> void:
	look_at(global_transform.origin + velocity)
	

func run() -> void:
	pass


func attack() -> void:
	pass
