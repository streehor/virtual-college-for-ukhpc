extends Node

var canvas_layer: CanvasLayer
var bg_rect: ColorRect
var status_label: Label

var http_request: HTTPRequest
var base_url: String = ""

var current_target_scene: String = ""
var is_downloading: bool = false
var is_resource_loading: bool = false

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	if OS.has_feature("web"):
		var js_code = "window.location.href.substring(0, window.location.href.lastIndexOf('/') + 1)"
		var url = JavaScriptBridge.eval(js_code)
		base_url = url if url != null else ""
		
	_create_loading_ui()

func _create_loading_ui():
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)
	
	bg_rect = ColorRect.new()
	bg_rect.color = Color(0, 0, 0, 1)
	bg_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(bg_rect)
	
	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg_rect.add_child(center)
	
	status_label = Label.new()
	status_label.text = tr("TR_LOADING")
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 40)
	center.add_child(status_label)
	
	canvas_layer.hide()

func load_scene(chunk_name: String, scene_path: String):
	await fade_in_loading()
	
	current_target_scene = scene_path
	status_label.text = tr("TR_LOADING")
	
	if not OS.has_feature("web") or chunk_name == "":
		_start_async_scene_load()
		return
		
	var save_path = "user://" + chunk_name + ".pck"
	
	if FileAccess.file_exists(save_path):
		status_label.text = tr("TR_MOUNTING")
		_mount_and_spawn(save_path)
	else:
		is_downloading = true
		status_label.text = tr("TR_DOWNLOADING")
		var full_url = base_url + chunk_name + ".pck" + "?v=" + str(Time.get_ticks_msec())
		http_request.download_file = save_path
		http_request.request(full_url)

func _mount_and_spawn(pck_path: String):
	var success = ProjectSettings.load_resource_pack(pck_path)
	if success:
		_start_async_scene_load()
	else:
		status_label.text = tr("TR_ERROR_MOUNT")

func _process(_delta):
	if is_resource_loading:
		var status = ResourceLoader.load_threaded_get_status(current_target_scene)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			is_resource_loading = false
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(current_target_scene))
			await fade_out_loading()
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			status_label.text = tr("TR_ERROR_LEVEL")
			is_resource_loading = false

func fade_in_loading():
	canvas_layer.show()
	bg_rect.modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(bg_rect, "modulate:a", 1.0, 0.5)
	await tween.finished

func fade_out_loading():
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	tween.tween_property(bg_rect, "modulate:a", 0.0, 0.8)
	await tween.finished
	
	canvas_layer.hide()

func _on_request_completed(_res, _code, _h, _b):
	is_downloading = false
	_mount_and_spawn(http_request.download_file)

func _start_async_scene_load():
	is_resource_loading = true
	ResourceLoader.load_threaded_request(current_target_scene, "", false, ResourceLoader.CACHE_MODE_IGNORE)
