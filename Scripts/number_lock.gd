extends Control

@onready var label: Label = $Panel/Panel2/Label
var current_code: String
var door_combo: String = "3872"
var can_try_code: bool = true
@onready var indicator: MeshInstance2D = $Panel/Indicator
@onready var timer: Timer = $Timer

func clear_text():
	label.text = ""
	current_code = ""
	
func flash_red_light():
	indicator.self_modulate = Color(1, 0, 0, 1)

func shine_green():
	indicator.self_modulate = Color(0, 1, 0, 1)
	
func try_code():
	if current_code == "3872":
		print("You got it!")
		shine_green()
		can_try_code = false
		timer.start()
	else:
		print("WRONG CODE")
		flash_red_light()
		print("%s does not equal %s" % [current_code, door_combo])
	clear_text()
	
func update_screen():
	if can_try_code:
		label.text = current_code

func _on_button_pressed() -> void:
	print(len(current_code))
	if len(current_code) < 4 and can_try_code:
		current_code += "1"
		update_screen()


func _on_button_2_pressed() -> void:
	if len(current_code) < 4 and can_try_code:
		current_code += "2"
		update_screen()

func _on_button_3_pressed() -> void:
	if len(current_code) < 4 and can_try_code:
		current_code += "3"
		update_screen()

func _on_button_4_pressed() -> void:
	if len(current_code) < 4 and can_try_code:
		current_code += "4"
		update_screen()

func _on_button_5_pressed() -> void:
	if len(current_code) < 4 and can_try_code:
		current_code += "5"
		update_screen()

func _on_button_6_pressed() -> void:
	if len(current_code) < 4 and can_try_code:
		current_code += "6"
		update_screen()

func _on_button_7_pressed() -> void:
	if len(current_code) < 4 and can_try_code:
		current_code += "7"
		update_screen()

func _on_button_8_pressed() -> void:
	if len(current_code) < 4 and can_try_code:
		current_code += "8"
		update_screen()

func _on_button_9_pressed() -> void:
	if len(current_code) < 4 and can_try_code:
		current_code += "9"
		update_screen()

func _on_button_10_pressed() -> void:
	if len(current_code) < 4 and can_try_code:
		current_code += "0"
		update_screen()

func _on_button_11_pressed() -> void:
	if len(current_code) == 4 and can_try_code:
		try_code()


func _on_timer_timeout() -> void:
	SignalManager.unlock_manager_door.emit()
