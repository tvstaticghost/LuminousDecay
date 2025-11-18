extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@export var movement_speed = 100
var target
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_root = get_tree().get_nodes_in_group("Player")[0]
	player = player_root.get_child(0)
	target = player.get_player_pos()
	navigation_agent_2d.target_position = target
	
func move_towards_player():
	if !navigation_agent_2d.is_navigation_finished():
		target = player.get_player_pos()
		navigation_agent_2d.target_position = target
		var next_target = navigation_agent_2d.get_next_path_position()
		var dir = (next_target - global_position).normalized()
		velocity = dir * movement_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	move_towards_player()
		
	move_and_slide()
