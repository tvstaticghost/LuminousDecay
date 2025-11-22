extends Node

var gradual_timer: Timer
var gradual_amount: float = 1.0
var darkness_timer: Timer
var darkness_timer_duration: float = 1.0
var damage_amount: float = 1.0
var darkness_value: float = 0

var max_darkness: float = 100.0
var min_darkness: float = 0

var is_in_danger: bool = false
var game_over: bool = false

func _ready() -> void:
	SignalManager.player_attacked.connect(increase_darkness)
	SignalManager.player_safe.connect(stop_dealing_darkness)
	
	darkness_timer = Timer.new()
	darkness_timer.wait_time = darkness_timer_duration
	darkness_timer.one_shot = true
	add_child(darkness_timer)
	darkness_timer.timeout.connect(_on_darkness_timer_timeout)
	
	gradual_timer = Timer.new()
	gradual_timer.wait_time = 5
	gradual_timer.autostart = true
	gradual_timer.one_shot = false
	add_child(gradual_timer)
	gradual_timer.timeout.connect(_on_gradual_timer_timeout)
	
func increase_darkness():
	print('enemy deals damage - game manager called to increase darkness')
	is_in_danger = true
	take_damage(damage_amount + 5)
	SignalManager.update_bar.emit(damage_amount + 5)
	darkness_timer.start()
	
func stop_dealing_darkness():
	print('Stopping darkness timer')
	is_in_danger = false
	darkness_timer.stop()

func die():
	#Toggle death screen and end the game
	print("Player has died")

func take_damage(amount: float):
	if !game_over:
		SignalManager.darken_screen.emit(amount)
		darkness_value += amount
		print('darkness level: %d' % darkness_value)
	
	if darkness_value >= max_darkness:
		die()
		
	
func _on_darkness_timer_timeout():
	if not is_in_danger:
		return
		
	SignalManager.update_bar.emit(damage_amount)
	take_damage(damage_amount)
	darkness_timer.start()

func _on_gradual_timer_timeout():
	print("gradual timeout!")
	SignalManager.update_bar.emit(gradual_amount)
	take_damage(gradual_amount)
