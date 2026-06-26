extends Node3D

var object_type: String # ID объекта из базы данных 
var panelOpened: bool = false # Блокировка клика открытым UI 
var press_position := Vector2.ZERO # Позиция мыши при нажатии 
var is_pressing : bool = false # Флаг удержания клика 
const DRAG_THRESHOLD := 5.0 # Лимит сдвига мыши для клика 

const ALPHA_BASE = 68 / 255.0 # Прозрачность в покое 
const ALPHA_HOVER = 255 / 255.0 # Прозрачность при наведении 
const FADE_DURATION = 0.2 # Время затухания/проявления 

var active_material : StandardMaterial3D # Уникальный материал зоны 
var fade_tween : Tween # Аниматор прозрачности 
var mouse_inside : bool = false # Флаг нахождения мыши над объектом

# Создание уникального материала объекта и привязка событий мыши
func _ready() -> void:
	Signalbus.connect("infopanel_opened", _on_panel_opened)
	Signalbus.connect("infopanel_closed", _on_panel_closed)
	
	var mesh_node = get_node_or_null("Area3D/MeshInstance3D")
	if mesh_node:
		var mat = mesh_node.material_override
		if not mat:
			mat = mesh_node.get_active_material(0)
		
		if mat:
			
			active_material = mat.duplicate()
			active_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			
			active_material.albedo_color.a = ALPHA_BASE
			mesh_node.material_override = active_material
	
	if has_node("Area3D"):
		$Area3D.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
		$Area3D.connect("mouse_entered", Callable(self, "_on_mouse_entered"))

# Сброс подсветки зоны при открытии инфопанели
func _on_panel_opened():
	panelOpened = true
	_animate_alpha(ALPHA_BASE)

# Восстановление подсветки, если после закрытия панели мышь осталась над объектом
func _on_panel_closed():
	panelOpened = false
	if mouse_inside:
		_animate_alpha(ALPHA_HOVER)

# Плавное включение подсветки при наведении курсора
func _on_mouse_entered():
	mouse_inside = true
	if not panelOpened or not Signalbus.is_menu_opened:
		_animate_alpha(ALPHA_HOVER)

# Плавное гашение подсветки при уходе курсора
func _on_mouse_exited():
	is_pressing = false
	mouse_inside = false
	_animate_alpha(ALPHA_BASE)

# Управление альфа-каналом материала через Tween
func _animate_alpha(target_alpha: float):
	if active_material:
		if fade_tween:
			fade_tween.kill()
		
		fade_tween = create_tween()
		fade_tween.tween_property(active_material, "albedo_color:a", target_alpha, FADE_DURATION)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

#Логика клика
func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if panelOpened or Signalbus.is_menu_opened:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_pressing = true
			press_position = event.position
		elif is_pressing:
			is_pressing = false
			if event.position.distance_to(press_position) < DRAG_THRESHOLD:
				if InteractableObjects.ObjectsDB.has(object_type):
					var data = InteractableObjects.ObjectsDB[object_type]
					Signalbus.emit_signal("share_infodata", data)
