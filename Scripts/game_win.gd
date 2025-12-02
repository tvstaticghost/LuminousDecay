extends Control

const WORLD = "res://Scenes/world.tscn"

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file(WORLD)
