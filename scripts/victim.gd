extends CharacterBody3D

@onready var victim_label: Label3D = $VictimLabel
@onready var label_timer: Timer = $VictimLabel/LabelTimer
@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $VictimLabel/AnimationPlayer

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

func _ready() -> void:
	victim_label.visible = false

func _physics_process(delta: float) -> void:
	pass

func damage() -> void:
	victim_label.visible = true
	victim_label.text = str(game_manager.kill_ponts)
	animation_player.play("appear")
	game_manager.add_point()
	print("victim dead")
	
	await animation_player.animation_finished
	victim_label.visible = false
