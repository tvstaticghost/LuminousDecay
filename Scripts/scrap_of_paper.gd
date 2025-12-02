extends Node2D

@onready var area_2d: Area2D = $Area2D
var is_being_collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.collect_note.connect(note_collected)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerBody"):
		body.toggle_note_interact(true)
		SignalManager.update_interact_text.emit("Press E to pick up item")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("PlayerBody") and not is_being_collected:
		SignalManager.clear_interact_text.emit()
		
	if body.is_in_group("PlayerBody"):
		body.toggle_note_interact(false)

func note_collected():
	is_being_collected = true
	SignalManager.update_interact_temp_text.emit("Note Collected - Something is written on it and is too hard to see")
	queue_free()
