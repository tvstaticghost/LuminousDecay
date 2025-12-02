extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.map_triggered.connect(toggle_map)

func toggle_map():
	visible = !visible
	
	if visible:
		SignalManager.stop_movement.emit(false)
	else:
		SignalManager.stop_movement.emit(true)

func _on_button_pressed() -> void:
	print("Map button pressed")
	if visible:
		visible = false
		
	SignalManager.stop_movement.emit(true)
