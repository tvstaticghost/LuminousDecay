extends Control

@onready var pistol_mag: TextureRect = $Panel/PistolMag
@onready var pistol_mag_2: TextureRect = $Panel/PistolMag2

@onready var bullet: TextureRect = $Panel/AmmoBox/Bullet
@onready var bullet_2: TextureRect = $Panel/AmmoBox/Bullet2
@onready var bullet_3: TextureRect = $Panel/AmmoBox/Bullet3

var bullet_1_dragging: bool = false
var bullet_2_dragging: bool = false
var bullet_3_dragging: bool = false

var offset_1: Vector2 = Vector2(0, 0)
var offset_2: Vector2 = Vector2(0, 0)
var offset_3: Vector2 = Vector2(0, 0)

var bullet_1_starting_position
var bullet_2_starting_position
var bullet_3_starting_position

var mag_location

#TODO NEED TO ADD BULLETS THEN ACCOUNT FOR HOW MANY BULLETS ARE LEFT IN INVENTORY
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.reload_triggered.connect(reload)
	
	bullet_1_starting_position = bullet.global_position
	bullet_2_starting_position = bullet_2.global_position
	bullet_3_starting_position = bullet_3.global_position
	
	var top_left = pistol_mag.global_position
	var mag_size = pistol_mag.size
	mag_location = Rect2(top_left, mag_size)
	
	check_bullet_amounts()

func reload():
	visible = !visible
	toggle_mag_sprite()
	
func check_bullet_amounts():
	var amount_to_render = BulletManager.bullets_in_inventory
	if amount_to_render >= 3:
		bullet.visible = true
		bullet_2.visible = true
		bullet_3.visible = true
	elif amount_to_render == 2:
		bullet.visible = false
		bullet_2.visible = true
		bullet_3.visible = true
	elif amount_to_render == 1:
		bullet.visible = false
		bullet_2.visible = false
		bullet_3.visible = true
	else:
		bullet.visible = false
		bullet_2.visible = false
		bullet_3.visible = false
		
func toggle_mag_sprite():
	if BulletManager.bullet_amount > 0:
		pistol_mag.visible = true
		pistol_mag_2.visible = false
	elif BulletManager.bullet_amount == 0:
		pistol_mag.visible = false
		pistol_mag_2.visible = true
		
	print('BULLET AMOUNT %d' % BulletManager.bullet_amount)

func _process(_delta: float) -> void:
	if bullet_1_dragging:
		bullet.global_position = get_global_mouse_position() - offset_1
	
	if bullet_2_dragging:
		bullet_2.global_position = get_global_mouse_position() - offset_2
		
	if bullet_3_dragging:
		bullet_3.global_position = get_global_mouse_position() - offset_3


func _on_button_1_button_down() -> void:
	bullet_1_dragging = true
	offset_1 = get_global_mouse_position() - bullet.global_position

func _on_button_1_button_up() -> void:
	bullet_1_dragging = false
	if mag_location.has_point(bullet.global_position):
		BulletManager.add_bullet_to_mag()
		check_bullet_amounts()
		toggle_mag_sprite()
		
	bullet.global_position = bullet_1_starting_position

func _on_button_2_button_down() -> void:
	bullet_2_dragging = true
	offset_2 = get_global_mouse_position() - bullet_2.global_position

func _on_button_2_button_up() -> void:
	bullet_2_dragging = false
	if mag_location.has_point(bullet_2.global_position):
		BulletManager.add_bullet_to_mag()
		check_bullet_amounts()
		toggle_mag_sprite()
		
	bullet_2.global_position = bullet_2_starting_position

func _on_button_3_button_down() -> void:
	bullet_3_dragging = true
	offset_3 = get_global_mouse_position() - bullet_3.global_position

func _on_button_3_button_up() -> void:
	bullet_3_dragging = false
	if mag_location.has_point(bullet_3.global_position):
		BulletManager.add_bullet_to_mag()
		check_bullet_amounts()
		toggle_mag_sprite()
		
	bullet_3.global_position = bullet_3_starting_position
