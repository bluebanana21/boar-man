extends Node3D
class_name State

var player = null 
@export var player_path:NodePath = "/root/World/SubViewportContainer/SubViewport/PlayerFPS"


signal Transitioned

func Enter()->void:
	pass

func Exit()->void:
	pass

func Update(_delta:float):
	pass

func Physics_update(_delta:float):
	pass
