extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var ammo_label: Label = $Panel/AmmoLabel
@onready var interact_text: Label = $InteractText
@onready var temp_timer: Timer = $TempTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.update_bar.connect(change_bar)
	SignalManager.gun_fired.connect(shot_fired)
	SignalManager.bullet_added.connect(added_bullet)
	SignalManager.update_interact_text.connect(update_text)
	SignalManager.clear_interact_text.connect(clear_text)
	SignalManager.update_interact_temp_text.connect(temp_text)
	
	ammo_label.text = str(BulletManager.bullet_amount) + "/" + str(BulletManager.max_bullets)
	
func change_bar(amount: float):
	progress_bar.value += amount
	print('Bar Progress: %d' % progress_bar.value)

func shot_fired(_direction: Vector2):
	ammo_label.text = str(BulletManager.bullet_amount) + "/" + str(BulletManager.max_bullets)

func added_bullet():
	ammo_label.text = str(BulletManager.bullet_amount) + "/" + str(BulletManager.max_bullets)

func update_text(text: String):
	interact_text.text = text

func clear_text():
	interact_text.text = ""

func temp_text(text:String):
	print("Called temp text")
	temp_timer.start()
	interact_text.text = text


func _on_temp_timer_timeout() -> void:
	clear_text()
	temp_timer.stop()
