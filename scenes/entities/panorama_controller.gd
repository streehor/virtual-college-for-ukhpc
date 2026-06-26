extends Node

# управляет отображением панорам и переходом между ними

@export var sphere_path : NodePath # Путь к 3D-сфере 
@export var camera_path : NodePath # Путь к камере 
@export var objects_manager : NodePath # Путь к менеджеру объектов 

@onready var sphere = get_node(sphere_path) # Ссылка на узел сферы 
@onready var camera = get_node(camera_path) # Ссылка на узел камеры 

var current_panorama = "" # ID текущей панорамы 
var tween : Tween # Аниматор переходов 
var sphere_mat : StandardMaterial3D # Материал сферы 

var texture_cache : Dictionary = {} # Кэш текстур локации 
var base_camera_pos : Vector3 # Исходная позиция камеры

# Настройка сферы, кэширование текстур локации и спавн стартовых объектов
func _ready() -> void:
	Signalbus.connect("arrow_clicked", Callable(self, "go_to")) # 

	base_camera_pos = camera.position # 

	sphere_mat = StandardMaterial3D.new() # 
	sphere_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED # 
	sphere_mat.cull_mode = BaseMaterial3D.CULL_DISABLED # 
	sphere.material_override = sphere_mat # 
	
	if AvailablePanoramas.AvPano: # 
		for pano_key in AvailablePanoramas.AvPano.keys(): # 
			var tex_path = AvailablePanoramas.AvPano[pano_key]["texture"] # 
			texture_cache[pano_key] = load(tex_path)

	current_panorama = "center"
	if texture_cache.has(current_panorama):
		var start_texture = texture_cache[current_panorama]
		override_panorama(start_texture, 0)
		var objects_mgr = get_node(objects_manager)
		if objects_mgr:
			objects_mgr.call_deferred("spawn_objects", start_texture.resource_path.get_file())
		
	update_arrows()
	
	await get_tree().process_frame
	await get_tree().process_frame
	

# Проверка условий и запуск смены панорамы или выхода в 3D-сцену
func go_to(direction: String):
	var current_data = AvailablePanoramas.AvPano[current_panorama]
	var next_panorama = current_data["transitions"][direction]

	if next_panorama == "":
		print("Переход невозможен:", direction)
		return

	if next_panorama == "exit":
		print("Выход с пано сцены")
		var scene_name = AvailablePanoramas.exit_map.get_file().get_basename()
		var chunk_name = "chunk_" + scene_name
		ChunkManager.load_scene(chunk_name, AvailablePanoramas.exit_map)
		return

	var next_data = AvailablePanoramas.AvPano[next_panorama]

	var current_yaw = current_data["rotation"]["base_yaw"]
	var next_yaw = next_data["rotation"]["base_yaw"]
	var world_angle = current_yaw + AvailablePanoramas.dir_angles[direction]
	var final_angle = world_angle - next_yaw

	current_panorama = next_panorama
	var next_texture = texture_cache[next_panorama]
	
	animate_transition(next_texture, final_angle)

# Твин-анимация легкого смещения камеры вперед/назад при переходе
func animate_transition(next_texture: Texture2D, final_angle: float, move_amount := 0.05):
	if not sphere:
		return

	if tween:
		tween.kill()

	tween = create_tween()
	var start_pos = base_camera_pos 
	
	var move_vec_out = Vector3.FORWARD.rotated(Vector3.UP, camera.rotation.y) * move_amount
	var next_cam_rad = deg_to_rad(final_angle)
	var move_vec_in = Vector3.FORWARD.rotated(Vector3.UP, next_cam_rad) * move_amount
	
	tween.tween_property(camera, "position", start_pos + move_vec_out, 0.25)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_callback(func():
		override_panorama(next_texture, final_angle)
		var objects_mgr = get_node(objects_manager)
		if objects_mgr:
			objects_mgr.reset_objects()
			objects_mgr.spawn_objects(next_texture.resource_path.get_file())
		update_arrows()
		camera.position = start_pos - move_vec_in
	)
	
	tween.tween_property(camera, "position", start_pos, 0.25)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# Обновление текстуры на сфере и вызов переключения ракурса
func override_panorama(new_texture: Texture2D, final_angle: float):
	if not sphere:
		return
	Signalbus.emit_signal("set_camera", final_angle)
	if sphere_mat:
		sphere_mat.albedo_texture = new_texture

# Фильтрация видимости стрелок переходов для текущей точки
func update_arrows():
	var t = AvailablePanoramas.AvPano[current_panorama]["transitions"]
	$ArrowForwardLeft.visible  = t["forward_left"] != ""
	$ArrowForward.visible      = t["forward"] != ""
	$ArrowForwardRight.visible = t["forward_right"] != ""
	$ArrowBackLeft.visible     = t["back_left"] != ""
	$ArrowBack.visible         = t["back"] != ""
	$ArrowBackRight.visible    = t["back_right"] != ""
	$ArrowLeft.visible         = t["left"] != ""
	$ArrowRight.visible        = t["right"] != ""
