extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.map_triggered.connect(toggle_map)

func toggle_map():
	visible = !visible


func _on_button_pressed() -> void:
	if visible:
		visible = false
