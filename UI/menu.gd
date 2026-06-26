extends Control

func _ready() -> void:
	hide_menu()
	Signalbus.connect("toggle_pause_menu", show_menu)
	Signalbus.connect("disable_pause_menu", hide_menu)

func show_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	$Panel/cont.disabled = false
	$Panel/exit.disabled = false
	$Panel/lang.disabled = false
	

func hide_menu():
	if get_tree().current_scene.scene_file_path != "res://debug.tscn":
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hide()
	$Panel/cont.disabled = true
	$Panel/exit.disabled = true
	$Panel/lang.disabled = true

func _process(delta: float) -> void:
	pass

func _on_lang_pressed() -> void:
	if Signalbus.current_lang == "ru":
		Signalbus.current_lang = "kk"
		TranslationServer.set_locale("kk")
	else:
		Signalbus.current_lang = "ru"
		TranslationServer.set_locale("ru")

func _on_cont_pressed() -> void:
	Signalbus.emit_signal("disable_pause_menu")
	Signalbus.is_menu_opened = false


func _on_exit_pressed() -> void:
	Signalbus.emit_signal("disable_pause_menu")
	Signalbus.is_menu_opened = false
	ChunkManager.load_scene("", "res://UI/main_menu.tscn")


func _on_fullscreen_pressed() -> void:
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
