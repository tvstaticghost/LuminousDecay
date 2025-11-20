extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.reload_triggered.connect(reload)

func reload():
	visible = !visible
