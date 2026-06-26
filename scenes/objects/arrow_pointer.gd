extends Node3D

@export var direction : String # Направление стрелки перехода 

const DRAG_THRESHOLD := 5.0 # Лимит сдвига мыши для клика 

var panel_opened : bool = false # Блокировка открытой инфопанелью 
var press_position := Vector2.ZERO # Позиция мыши при нажатии 
var is_pressing : bool = false # Флаг удержания кнопки мыши 

func _ready():
	$arrow/Area3D.connect("input_event", Callable(self, "_on_area_input_event"))
	Signalbus.connect("infopanel_opened", Callable(self, "_on_panel_opened"))
	Signalbus.connect("infopanel_closed", Callable(self, "_on_panel_closed"))
	Signalbus.connect("toggle_pause_menu", Callable(self, "_on_panel_opened"))
	Signalbus.connect("disable_pause_menu", Callable(self, "_on_panel_closed"))

func _on_panel_opened():
	panel_opened = true
	visible = false
	is_pressing = false

func _on_panel_closed():
	panel_opened = false
	var panorama_controller = get_node_or_null("../") 
	
	if not panorama_controller or not panorama_controller.has_method("update_arrows"):
		panorama_controller = get_tree().current_scene.get_node_or_null("PanoramaController")
	
	if panorama_controller and panorama_controller.has_method("update_arrows"):
		panorama_controller.update_arrows()

func _on_area_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if panel_opened:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_pressing = true
			press_position = event.position
		elif is_pressing:
			is_pressing = false
			if event.position.distance_to(press_position) < DRAG_THRESHOLD:
				Signalbus.emit_signal("arrow_clicked", direction)
