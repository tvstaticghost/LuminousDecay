extends Control

@onready var point_light_2d: PointLight2D = $TextureRect/PointLight2D
const WORLD = "res://Scenes/world.tscn"

var brightness: float
var flicker_speed: float = 10.0  # higher = faster flicker

func _ready() -> void:
	brightness = point_light_2d.energy

func _process(delta: float) -> void:
	var target = randf_range(2.5, 5.0)  # subtle flicker range
	brightness = lerp(brightness, target, flicker_speed * delta)
	point_light_2d.energy = brightness


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(WORLD)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
