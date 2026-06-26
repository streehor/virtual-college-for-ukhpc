extends Node

var current_lang = "ru"

# Синглтон для связывания событий
signal arrow_clicked(direction)
signal update_arrows(transitions)

signal reset_camera()
signal set_camera(direction, base_yaw)
signal open_infopanel()

signal share_infodata(data : Dictionary)
signal infopanel_opened()
signal infopanel_closed()

signal open_floor_panel(floors)

signal door_clicked(collider)

var door_id: int = -1 # ID двери
var player_rotation : Vector3 = Vector3.ZERO # Буфер поворота
var player_position : Vector3 = Vector3.ZERO # Буфер позиции

signal toggle_pause_menu()
signal disable_pause_menu()

var is_menu_opened = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if is_menu_opened:
			emit_signal("disable_pause_menu")
			is_menu_opened = false
		else:
			emit_signal("toggle_pause_menu")
			is_menu_opened = true
