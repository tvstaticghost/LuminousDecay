extends Control

@export var starting_enery: float = 1.0
var current_energy: float
@export var energy_step_amount: float = 0.2
@onready var point_light_2d: PointLight2D = $TextureRect/PointLight2D

const WORLD = "res://Scenes/world.tscn"

@onready var timer: Timer = $Timer

func _ready() -> void:
	current_energy = starting_enery

# Called when the node enters the scene tree for the first time.
func _process(_delta: float) -> void:
	point_light_2d.energy = current_energy
	if current_energy <= 0:
		timer.stop()

func _on_timer_timeout() -> void:
	current_energy -= energy_step_amount


func _on_start_button_pressed() -> void:
	SignalManager.game_restarting.emit()
	get_tree().change_scene_to_file(WORLD)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
