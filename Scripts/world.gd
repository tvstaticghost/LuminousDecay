extends Node2D

@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

@onready var enemy_spawn_points: Node = $EnemySpawnPoints


var starting_level: float = 0.4
var current_darkness_level: float
var max_level: float = 1.0

func _ready() -> void:
	current_darkness_level = starting_level
	color_rect.color = Color(0, 0, 0, starting_level)
	SignalManager.darken_screen.connect(darken)
	
	generate_enemy_spawn_location_list()
	
func generate_enemy_spawn_location_list():
	for point in enemy_spawn_points.get_children():
		print(point)
	
func darken(amount: float):
	# Increase darkness
	current_darkness_level += amount
	print("WORLD Darkness Level: %d " % current_darkness_level)

	color_rect.color.a = (0.006 * current_darkness_level) + 0.4
