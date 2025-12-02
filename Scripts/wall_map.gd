extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerBody"):
		body.toggle_map_interact(true)
		SignalManager.update_interact_text.emit("Press E to interact with map")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("PlayerBody"):
		body.toggle_map_interact(false)
		SignalManager.clear_interact_text.emit()
