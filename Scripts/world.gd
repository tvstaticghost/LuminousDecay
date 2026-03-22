extends Node2D

@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var microscope: Control = $CanvasLayer/Microscope
@onready var number_lock: Control = $CanvasLayer/NumberLock
@onready var monster_spawn_timer: Timer = $MonsterSpawnTimer
const ENEMY = preload("uid://b0a8gj5ua547s")

const GAMEWIN = "res://Scenes/game_win.tscn"



@onready var enemy_spawn_points: Node = $EnemySpawnPoints
var spawn_points = []

@export var starting_level: float = 0.4
var current_darkness_level: float
var max_level: float = 1.0

func _ready() -> void:
	current_darkness_level = starting_level
	color_rect.color = Color(0, 0, 0, starting_level)
	SignalManager.darken_screen.connect(darken)
	SignalManager.look_at_microscope.connect(view_microscope)
	SignalManager.toggle_door_lock.connect(door_lock)
	SignalManager.unlock_manager_door.connect(door_unlocked)
	
	generate_enemy_spawn_location_list()
	SignalManager.world_scene_loaded.emit()
	
func generate_enemy_spawn_location_list():
	for point in enemy_spawn_points.get_children():
		spawn_points.append(point.global_position)
	
func darken(amount: float):
	# Increase darkness
	current_darkness_level += amount
	print("WORLD Darkness Level: %d " % current_darkness_level)

	color_rect.color.a = (0.006 * current_darkness_level) + 0.4

func view_microscope():
	microscope.visible = !microscope.visible
	
	SignalManager.stop_movement.emit(!microscope.visible)
		
func door_lock():
	number_lock.visible = !number_lock.visible
	SignalManager.stop_movement.emit(!number_lock.visible)
	
func door_unlocked():
	number_lock.visible = false
	SignalManager.stop_movement.emit(true)


func _on_monster_spawn_timer_timeout() -> void:
	var enemy_inst = ENEMY.instantiate()
	enemy_inst.global_position = spawn_points[randi_range(0, len(spawn_points) - 1)]
	add_child(enemy_inst)
	print("Enemy spawned into scene")

func _on_winning_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerBody"):
		get_tree().change_scene_to_file(GAMEWIN)
