extends CharacterBody3D

@onready var victim_label = $Label3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
var combo_points: int = 100

func _ready() -> void:
	victim_label.visible = false

func _physics_process(delta: float) -> void:
	pass

func damage() -> void:
	victim_label.visible = true
	victim_label.text = "100"
	print("victim dead")
