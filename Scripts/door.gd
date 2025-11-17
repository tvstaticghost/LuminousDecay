extends Node2D

@onready var pivot_point: Marker2D = $PivotPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door_timer: Timer = $DoorTimer

var can_open: bool = true
var locked: bool = false
var door_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func test():
	if !locked and can_open:
		door_open = !door_open
		if door_open:
			print("opening door")
			animation_player.play("door_open")
		else:
			print("closing door")
			animation_player.play("door_close")
		can_open = false
		door_timer.start()


func _on_door_timer_timeout() -> void:
	can_open = true
	door_timer.stop()
