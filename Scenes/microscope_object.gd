extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerBody") and GameManager.has_paper:
		SignalManager.update_interact_text.emit("Press E to use microscope")
		body.toggle_microscope_interact(true)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("PlayerBody"):
		SignalManager.clear_interact_text.emit()
		body.toggle_microscope_interact(false)
