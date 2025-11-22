extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var ammo_label: Label = $Panel/AmmoLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.update_bar.connect(change_bar)
	SignalManager.gun_fired.connect(shot_fired)
	SignalManager.bullet_added.connect(added_bullet)
	
	ammo_label.text = str(BulletManager.bullet_amount) + "/" + str(BulletManager.max_bullets)
	
func change_bar(amount: float):
	progress_bar.value += amount
	print('Bar Progress: %d' % progress_bar.value)

func shot_fired(_direction: Vector2):
	ammo_label.text = str(BulletManager.bullet_amount) + "/" + str(BulletManager.max_bullets)

func added_bullet():
	ammo_label.text = str(BulletManager.bullet_amount) + "/" + str(BulletManager.max_bullets)
