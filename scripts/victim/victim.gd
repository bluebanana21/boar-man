extends CharacterBody3D

class_name victim

@onready var victim_label: Label3D = $VictimLabel
@onready var label_timer: Timer = $VictimLabel/LabelTimer
@onready var game_manager: Node = $"../../GameManager"
@onready var animation_player: AnimationPlayer = $VictimLabel/AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var fov_cast: RayCast3D = $FOVCast


func damage() -> void:
	victim_label.visible = true
	victim_label.text = str(game_manager.kill_ponts)
	animation_player.play("appear")
	game_manager.add_point()
	print("victim dead")
	
	await animation_player.animation_finished
	victim_label.visible = false
