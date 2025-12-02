extends Node2D

@onready var pivot_point: Marker2D = $PivotPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door_timer: Timer = $DoorTimer
@onready var door_locked_sound: AudioStreamPlayer2D = $DoorLockedSound

var can_open: bool = true
@export var locked: bool = false
var door_open: bool = false

func test():
	print(GameManager.has_card_key)
	if GameManager.has_card_key and can_open:
		door_open = !door_open
		if door_open:
			print("opening door")
			animation_player.play("door_open")
		else:
			print("closing door")
			animation_player.play("door_close")
		can_open = false
		door_timer.start()
	else:
		animation_player.play("door_locked")

func _on_door_timer_timeout() -> void:
	can_open = true
	door_timer.stop()
