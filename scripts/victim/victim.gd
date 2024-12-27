extends CharacterBody3D
class_name victim

@onready var victim_label: Label3D = $VictimLabel
@onready var game_manager: Node = $"../../../GameManager"
@onready var label_animation: AnimationPlayer = $VictimLabel/LabelAnimation


func damage() -> void:
	victim_label.visible = true
	victim_label.text = str(game_manager.kill_ponts)
	label_animation.play("appear")
	game_manager.add_point()
	print("victim dead")
	
	await label_animation.animation_finished
	victim_label.visible = false
