extends Node2D

@onready var bullet_visual: Sprite2D = $BulletVisual
@export var rotation_speed: float = 100
@export var top_speed: float = 300

var target_angle: float
var current_rotation: float
var dir: Vector2
var current_speed: float
var reduction_amount: float
var fired: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.gun_fired.connect(receive_transform)
	target_angle = randf_range(-20, -80)
	current_rotation = rotation
	dir = Vector2.ZERO
	current_speed = top_speed
	reduction_amount = randf_range(4, 6)

func receive_transform(right: Vector2):
	if !fired:
		dir = right
		fired = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rotation = lerp_angle(current_rotation, target_angle, rotation_speed * delta)
	position += dir * current_speed * delta
	
	if current_speed > 0:
		current_speed -= reduction_amount
	else:
		current_speed = 0
