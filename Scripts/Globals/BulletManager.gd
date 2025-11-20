extends Node

@export var bullet_amount: int = 7

func _ready() -> void:
	SignalManager.gun_fired.connect(shot_fired)
	
func shot_fired(_direction: Vector2):
	if bullet_amount > 0:
		bullet_amount -= 1
		print('Fired shot')
	else:
		print('Out of ammo')
