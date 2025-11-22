extends Node

@export var bullet_amount: int = 7
var max_bullets: int = 7
var bullets_in_inventory: int = 7

func _ready() -> void:
	SignalManager.gun_fired.connect(shot_fired)
	
func shot_fired(_direction: Vector2):
	if bullet_amount > 0:
		bullet_amount -= 1
		print('Fired shot')
	else:
		print('Out of ammo')
		
func add_bullet_to_mag():
	if bullets_in_inventory > 0:
		if bullet_amount < max_bullets:
			bullet_amount += 1
			bullets_in_inventory -= 1
			print("Bullet added = now has %d" % bullet_amount)
			SignalManager.bullet_added.emit()
		else:
			print("You already have 7 bulletss")
	else:
		print("You have no bullets")
