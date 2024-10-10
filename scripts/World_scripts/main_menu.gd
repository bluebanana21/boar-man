extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/World_scenes/world.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
