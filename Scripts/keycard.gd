extends Node2D

var is_being_collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.collect_keycard.connect(keycard_collected)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerBody"):
		body.toggle_keycard_interact(true)
		SignalManager.update_interact_text.emit("Press E to pick up item")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("PlayerBody") and not is_being_collected:
		body.toggle_keycard_interact(false)
		SignalManager.clear_interact_text.emit()
		
	if body.is_in_group("PlayerBody"):
		body.toggle_keycard_interact(false)

func keycard_collected():
	is_being_collected = true
	SignalManager.update_interact_temp_text.emit("Keycard Collected")
	queue_free()
