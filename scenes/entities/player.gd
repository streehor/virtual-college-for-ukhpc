extends CharacterBody3D

var SPEED = 18.0 

@export var mouse_sensitivity := 0.002 
@onready var camera = $Camera3D 
@onready var raycast = $RayCast3D 
@export var crosshair_label : Label 

var mouse_delta := Vector2.ZERO 
var rotation_x := 0.0 

var menu_opened : bool = false 
var is_info_open : bool = false
var is_pause_open : bool = false

var is_warming_up : bool = true 

func _ready():
	add_to_group("player")
	
	Signalbus.connect("infopanel_opened", _on_info_opened)
	Signalbus.connect("infopanel_closed", _on_info_closed)
	
	Signalbus.connect("toggle_pause_menu", _on_pause_opened)
	Signalbus.connect("disable_pause_menu", _on_pause_closed)
	
	if typeof(AvailablePanoramas.exit_position) == TYPE_VECTOR3:
		global_position = AvailablePanoramas.exit_position
		rotation = Vector3(0, deg_to_rad(AvailablePanoramas.exit_rotation.y), 0)
		AvailablePanoramas.exit_position = null
		AvailablePanoramas.exit_rotation = Vector3.ZERO
		
	elif typeof(FloorManager.target_position) == TYPE_VECTOR3:
		global_position = FloorManager.target_position
		rotation = Vector3(0, deg_to_rad(FloorManager.target_rotation), 0)
		
		FloorManager.target_position = null
		FloorManager.target_rotation = null
	
	camera.rotation = Vector3.ZERO
	rotation_x = 0.0
	mouse_delta = Vector2.ZERO
	
	warm_up_shaders()

func warm_up_shaders():
	is_warming_up = true
	var original_rotation_y = rotation.y
	
	for i in range(4):
		rotation.y += PI / 2.0
		await get_tree().process_frame
		await get_tree().process_frame
	
	rotation.y = original_rotation_y
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	is_warming_up = false
	

func _input(event):
	if menu_opened or is_warming_up: return
	
	if event is InputEventMouseMotion:
		mouse_delta += event.relative
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if raycast.is_colliding():
			Input.action_release("mouse_click")
			var collider = raycast.get_collider()
			
			Signalbus.emit_signal("door_clicked", collider)
			
			if collider.is_in_group("inter3d"):
				_trigger_inter3d_object(collider)
			get_viewport().set_input_as_handled()

func _trigger_inter3d_object(collider: Node) -> void:
	var parent = collider.get_parent()
	for child in parent.get_children():
		if child.has_method("open_info_panel"):
			child.open_info_panel()
			return

func _unhandled_input(event):
	if is_warming_up: return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not menu_opened:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				
	if event.is_action_pressed("ui_cancel"):
		if not menu_opened:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	if menu_opened or is_warming_up:
		velocity = Vector3.ZERO
		move_and_slide()
		if crosshair_label: crosshair_label.text = "+"
		return
		
	SPEED = 8.0 if Input.is_action_pressed("sprint") else 4.0
	if not is_on_floor(): 
		velocity += get_gravity() * delta
		
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
	rotate_y(-mouse_delta.x * mouse_sensitivity)
	rotation_x = clamp(rotation_x - mouse_delta.y * mouse_sensitivity, deg_to_rad(-90), deg_to_rad(90))
	camera.rotation.x = rotation_x
	mouse_delta = Vector2.ZERO
	
	if crosshair_label:
		if raycast.is_colliding():
			crosshair_label.text = "O"
		else:
			crosshair_label.text = "+"

func _on_info_opened() -> void:
	is_info_open = true
	_update_ui_state()

func _on_info_closed() -> void:
	is_info_open = false
	_update_ui_state()

func _on_pause_opened() -> void:
	is_pause_open = true
	_update_ui_state()

func _on_pause_closed() -> void:
	is_pause_open = false
	_update_ui_state()

func _update_ui_state() -> void:
	menu_opened = is_info_open or is_pause_open
	
	if menu_opened:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
