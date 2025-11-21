extends CharacterBody2D

@onready var player_cast: RayCast2D = $PlayerCast
@onready var enemy_visuals: AnimatedSprite2D = $EnemyVisuals
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@export var movement_speed = 70
@export var vision_distance: float = 270
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var health: int = 30

var target
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_root = get_tree().get_nodes_in_group("Player")[0]
	player = player_root.get_child(0)
	target = player.get_player_pos()
	navigation_agent_2d.target_position = target
	enemy_visuals.play("crawl")
	
func move_towards_player():
	if !navigation_agent_2d.is_navigation_finished():
		target = player.get_player_pos()
		navigation_agent_2d.target_position = target
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	move_towards_player()
	
	var distance = global_position.distance_to(player.global_position)
	if distance < vision_distance:
		if player_cast.is_colliding():
			var hit = player_cast.get_collider()
			print(hit)
			if hit.is_in_group("PlayerBody"):
				enemy_visuals.visible = true
	else:
		enemy_visuals.visible = false
	
	move_and_slide()
	
func die():
	print('Enemy died')
	queue_free() #Change this to a death animation and disable collisions

func take_damage(amount: int):
	if health > 0:
		health -= amount
		
	if health <= 0:
		die()
