extends CharacterBody3D
class_name Victim

signal health_depleted

@onready var victim_label: Label3D = $VictimLabel
@onready var game_manager: Node = $"../../../GameManager"
@onready var label_animation: AnimationPlayer = $VictimLabel/LabelAnimation
@onready var state_machine: Node = $StateMachine

func _ready() -> void:
	print(state_machine.current_state)

#Func is called when player kill victim, make it instakill so a helth variable is unnecessary
func damage() -> void:
#	makes the point counter above victim head visible
#	and changes the label text to be the same as the kill points variable defined in game manager
	victim_label.visible = true
	victim_label.text = str(game_manager.kill_ponts)
	
#	playes the label animation, and adds kill points to the point counter in the game manager node
	label_animation.play("appear")
	game_manager.add_point()
	
#	emits the health depleted signal, transitioning the victim state to the death state
	health_depleted.emit()
	print("victim dead")
	
#	waits for the label animation to finish and makes it invisible again
	await label_animation.animation_finished
	victim_label.visible = false


func _on_state_machine_report_state(current_state: Variant) -> void:
	pass
