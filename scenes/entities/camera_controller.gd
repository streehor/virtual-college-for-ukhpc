extends Node

@export var camera : Camera3D # Камера панорамы 
@export var smoothness : float = 10.0 # Плавность вращения и зума 
@export var sensitivity : float = 0.002 # Чувствительность мыши 

var last_x = 0 # Прошлая X-позиция мыши 
var last_y = 0 # Прошлая Y-позиция мыши 

var max_look_down = 30.0 # Лимит взгляда вниз 
var max_look_up = 80.0 # Лимит взгляда вверх 
var min_fov = 30.0 # Максимальный зум 
var max_fov = 75.0 # Минимальный зум 
var fov_step = 7.0 # Шаг зума 

var camera_locked : bool = false # Блокировка обзора интерфейсом 

var target_yaw : float = 0.0 # Целевой поворот по горизонтали 
var target_pitch : float = 0.0 # Целевой поворот по вертикали 
var target_fov = 75.0 # Целевой угол обзора

# Инициализация подписок на сигналы и сброс ракурса
func _ready() -> void:
	Signalbus.connect("reset_camera", reset_camera)
	Signalbus.connect("set_camera", set_camera)
	Signalbus.connect("infopanel_opened", _on_infopanel_opened)
	Signalbus.connect("infopanel_closed", _on_infopanel_closed)
	Signalbus.connect("toggle_pause_menu", _on_infopanel_opened)
	Signalbus.connect("disable_pause_menu", _on_infopanel_closed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	reset_camera()

# Блокировка вращения при открытии инфопанели
func _on_infopanel_opened():
	camera_locked = true

# Разблокировка вращения при закрытии инфопанели
func _on_infopanel_closed():
	camera_locked = false

# Чтение ввода мыши для драга и кнопок для зума
func _input(event):
	if camera_locked:
		return

	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("mouse_click"):
			last_x = event.position.x
			last_y = event.position.y
	elif event is InputEventMouseMotion and Input.is_action_pressed("mouse_click"):
		var dx = (last_x - event.position.x) * sensitivity
		var dy = (last_y - event.position.y) * sensitivity
		last_x = event.position.x
		last_y = event.position.y
		rotate_camera(-dx, -dy)

	if Input.is_action_pressed("zoom_in"):
		target_fov = clamp(target_fov - fov_step, min_fov, max_fov)
	elif Input.is_action_pressed("zoom_out"):
		target_fov = clamp(target_fov + fov_step, min_fov, max_fov)
	elif Input.is_action_pressed("zoom_reset"):
		target_fov = 75.0

# Покадровое сглаживание вращения и FOV камеры
func _process(delta: float) -> void:
	camera.rotation.y = lerp_angle(camera.rotation.y, target_yaw, smoothness * delta)
	camera.rotation.x = lerp(camera.rotation.x, target_pitch, smoothness * delta)
	camera.fov = lerp(camera.fov, target_fov, smoothness * delta)

# Расчет целевых углов вращения с ограничением по вертикали
func rotate_camera(dx: float, dy: float):
	target_yaw += dx 
	target_pitch += dy 
	
	var min_pitch = -deg_to_rad(max_look_up) 
	var max_pitch = deg_to_rad(max_look_down) 
	
	target_pitch = clamp(target_pitch, min_pitch, max_pitch) 

# Мгновенный разворот камеры при программной смене панорамы
func set_camera(final_angle: float):
	target_pitch = 0.0 
	target_yaw = deg_to_rad(final_angle) 
	
	camera.rotation.x = 0.0 
	camera.rotation.z = 0.0 
	camera.rotation.y = target_yaw

# Сброс углов и зума в дефолтное состояние
func reset_camera():
	target_yaw = 0.0
	target_pitch = 0.0
	camera.rotation = Vector3.ZERO 
	camera.fov = 75.0
