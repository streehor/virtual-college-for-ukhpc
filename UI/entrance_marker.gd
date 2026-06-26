extends Node3D

@export var rotation_speed: float = 2.5
@export var bobbing_speed: float = 3.0
@export var bobbing_height: float = 0.15

var start_y: float

func _ready() -> void:
	start_y = global_position.y

func _process(delta: float) -> void:
	rotate_y(rotation_speed * delta)
	
	global_position.y = start_y + sin(Time.get_ticks_msec() / 1000.0 * bobbing_speed) * bobbing_height
