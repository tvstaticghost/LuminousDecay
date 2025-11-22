extends CharacterBody2D

@onready var gun_empty: AudioStreamPlayer = $"../GunEmpty"
@onready var gun_aim_sound: AudioStreamPlayer = $"../GunAimSound"
@onready var gun_shot_sound: AudioStreamPlayer = $"../GunShotSound"
@onready var gun_reload_sound: AudioStreamPlayer = $"../GunReloadSound"
@onready var ghost_whispers: AudioStreamPlayer = $"../GhostWhispers"
@onready var interact_cast: RayCast2D = $InteractCast
@onready var bullet_cast: RayCast2D = $BulletCast

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var muzzle_flash: Sprite2D = $MuzzleFlash
@onready var muzzle_flash_timer: Timer = $MuzzleFlashTimer
@onready var ejection_port: Marker2D = $EjectionPort
const BULLET = preload("uid://nbhfnfyj62ph")

@onready var blood_sound_1: AudioStreamPlayer = $"../BloodSound1"
@onready var blood_sound_2: AudioStreamPlayer = $"../BloodSound2"
@onready var blood_sound_3: AudioStreamPlayer = $"../BloodSound3"
var blood_sound_list = []

@export var speed: float = 250
@export var rotation_speed = 6
@export var accel := 3000.0
@export var original_i_value: float = 0.0

var can_walk: bool = true
var walking: bool = false
var is_aiming: bool = false
var in_map_area: bool = false

var ghost_fade_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blood_sound_list.append(blood_sound_1)
	blood_sound_list.append(blood_sound_2)
	blood_sound_list.append(blood_sound_3)
	
func play_animation(animation: String):
	animated_sprite_2d.play(animation)
	
func check_for_footsteps():
	if animated_sprite_2d.animation == "walk":
		if animated_sprite_2d.frame == 7 or animated_sprite_2d.frame == 3:
			pass

func get_input(delta: float):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var target_velocity = input_direction * speed
	
	if input_direction != Vector2.ZERO:
		if animated_sprite_2d.animation == "aim":
			play_animation("walk")
			
		if walking == false:
			walking = true
			play_animation("walk")
		
		velocity = velocity.move_toward(target_velocity, accel * delta)
		rotation = lerp_angle(rotation, velocity.angle() + -PI/2, rotation_speed * delta)
		
		check_for_footsteps()
	else:
		walking = false
		play_animation("idle")
		velocity = Vector2.ZERO
		
func aiming(delta):
	is_aiming = true
	can_walk = false
	velocity = Vector2.ZERO
	var direction = get_global_mouse_position() - global_position
	rotation = lerp_angle(rotation, direction.angle() + -PI/2, rotation_speed * delta)
	if animated_sprite_2d.animation != "aim":
		gun_aim_sound.play()
		play_animation("aim")
		
		
func fire_gun():
	if BulletManager.bullet_amount > 0:
		
		muzzle_flash_timer.start()
		muzzle_flash.visible = true
		gun_shot_sound.play()
		var bullet_inst = BULLET.instantiate()
		get_tree().root.add_child(bullet_inst)
		bullet_inst.global_position = ejection_port.global_position
		SignalManager.gun_fired.emit(-ejection_port.global_transform.x)
		
		if bullet_cast.is_colliding():
			var hit = bullet_cast.get_collider()
			#If hitting an enemy - deal damage
			if hit.is_in_group("Enemy"):
				print('You hit an enemy')
				hit.get_parent().take_damage(10)
				var direction = bullet_cast.global_transform.x
				hit.get_parent().spawn_blood(direction)
				var blood_sound = blood_sound_list[randi_range(0, len(blood_sound_list) - 1)]
				blood_sound.play()
			elif hit.is_in_group("Walls"):
				print('You hit the walls')
				#TODO if time allows - add a little particle effect when hitting a wall.
	else:
		#Handle empty mag logic
		gun_empty.play()
	
func handle_interact():
	if in_map_area:
		SignalManager.map_triggered.emit()
		return
		
	if interact_cast.is_colliding():
		var hit = interact_cast.get_collider()
		if hit != null and hit.is_in_group("Door"):
			print("Hit a door!")
			var parent_node = hit.get_parent().get_parent()
			parent_node.test()
	else:
		print("Nothing to interact with")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		handle_interact()
		
	if Input.is_action_pressed("aim"):
		aiming(delta)
	else:
		is_aiming = false
		can_walk = true
		
	if Input.is_action_just_pressed("shoot"):
		if !is_aiming:
			return
		
		fire_gun()
		
	if Input.is_action_just_pressed("reload"):
		SignalManager.reload_triggered.emit()
		
	if can_walk:
		get_input(delta)
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	print("animation finished")
	if animated_sprite_2d.animation == "shoot":
		if is_aiming:
			play_animation("aim")


func _on_muzzle_flash_timer_timeout() -> void:
	muzzle_flash.visible = false
	muzzle_flash_timer.stop()

func get_player_pos():
	return global_position

func toggle_map_interact(in_area: bool):
	in_map_area = in_area
	

func fade_in_ghost():
	var tween = create_tween()
	ghost_whispers.volume_db = -20  # start quiet
	ghost_whispers.play()
	tween.tween_property(ghost_whispers, "volume_db", 0, 1.5) # fade to full over 1.5 sec

func fade_out_ghost():
	var tween = create_tween()
	tween.tween_property(ghost_whispers, "volume_db", -40, 1.5) # fade to silence
	tween.tween_callback(ghost_whispers.stop)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		print('enemy deals damage - player attacked trigger event')
		animated_sprite_2d.self_modulate.v = 10.0
		fade_in_ghost()
		SignalManager.player_attacked.emit()


func _on_hurtbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		print('enemy done dealing damage - player safe trigger event')
		animated_sprite_2d.self_modulate.v = 1.0
		fade_out_ghost()
		SignalManager.player_safe.emit()
