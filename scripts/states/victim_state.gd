extends Node3D
class_name VictimState


@export var player_path: NodePath = "/root/World/SubViewportContainer/SubViewport/PlayerFPS"
@onready var player = get_node(player_path) 

var victim_health:= 50

signal Transitioned

func Enter()->void:
	pass

func Exit()->void:
	pass

func Update(_delta:float):
	pass

func Physics_update(_delta:float):
	pass
