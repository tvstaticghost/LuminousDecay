extends CharacterBody2D

@onready var player_cast: RayCast2D = $PlayerCast
@onready var enemy_visuals: AnimatedSprite2D = $EnemyVisuals
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@export var movement_speed = 70
@export var vision_distance: float = 270
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@onready var strings_1: AudioStreamPlayer2D = $Strings1
@onready var strings_2: AudioStreamPlayer2D = $Strings2
@onready var strings_3: AudioStreamPlayer2D = $Strings3
var strings_list = []
var enemy_revealed: bool = false

const BLOOD_1 = preload("uid://dj53uxso6b8db")
const BLOOD_2 = preload("uid://cwvcam8ihn1ab")
const BLOOD_3 = preload("uid://fxgm1svx17yj")

var blood_list = [BLOOD_1, BLOOD_2, BLOOD_3]
var ending_scale

@export var health: int = 30

var target_reached: bool = false
var target
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	strings_list.append(strings_1)
	strings_list.append(strings_2)
	strings_list.append(strings_3)
	print(strings_list)
	
	ending_scale = Vector2(0.15, 0.15)
	var player_root = get_tree().get_nodes_in_group("Player")[0]
	player = player_root.get_child(0)
	target = player.get_player_pos()
	navigation_agent_2d.target_position = target
	enemy_visuals.play("crawl")
	
func move_towards_player():
	target = player.get_player_pos()
	navigation_agent_2d.target_position = target
	
	if !navigation_agent_2d.is_navigation_finished():
		if target_reached:
			target_reached = false
			
		var next_target = navigation_agent_2d.get_next_path_position()
		look_at(next_target)
		rotation += deg_to_rad(-90)
		var dir = (next_target - global_position).normalized()
		velocity = dir * movement_speed
		
		if ray_cast_2d.is_colliding():
			var hit = ray_cast_2d.get_collider()
			if hit != null and hit.is_in_group("Door"):
				var parent_node = hit.get_parent().get_parent()
				parent_node.test()
	else:
		target_reached = true
		velocity = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	move_towards_player()
	
	var distance = global_position.distance_to(player.global_position)
	if distance < vision_distance:
		if player_cast.is_colliding():
			var hit = player_cast.get_collider()
			if hit.is_in_group("PlayerBody"):
				enemy_visuals.self_modulate.a = 1
				if !enemy_revealed:
					enemy_revealed = true
					var string = strings_list[randi_range(0, len(strings_list) - 1)]
					string.play()
	else:
		#enemy_visuals.visible = false
		enemy_visuals.self_modulate.a = 0.01
		enemy_revealed = false
	
	move_and_slide()
	
func spawn_blood(direction: Vector2):
	var blood_inst = blood_list[randi_range(0, len(blood_list) - 1)]
	var blood_object = blood_inst.instantiate()
	get_tree().get_root().add_child(blood_object)
	blood_object.global_position = global_position
	blood_object.z_index = 2
	blood_object.scale = Vector2(0.01, 0.01)
	
	var dir = direction.rotated(deg_to_rad(90))
	var target_pos = blood_object.global_position + dir * 20
	var tween = get_tree().create_tween()
	tween.tween_property(
		blood_object,
		"global_position",
		target_pos,
		0.2 # change value to make it faster or slower
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		blood_object,
		"scale",
		ending_scale, # final size
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	blood_object.rotation = (-dir).angle() + randf_range(-0.4, 0.4)
	
func die():
	print('Enemy died')
	queue_free() #Change this to a death animation and disable collisions

func take_damage(amount: int):
	if health > 0:
		health -= amount
		
	if health <= 0:
		die()
