extends Control

@onready var vbox = $VBoxContainer
@onready var label = $Label

func _ready():
	hide()
	Signalbus.connect("open_floor_panel", Callable(self, "open_panel"))
	Signalbus.connect("toggle_pause_menu", close_panel_force)

func open_panel(floors: Array):
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Signalbus.emit_signal("infopanel_opened")
	
	for child in vbox.get_children():
		if child is Button:
			child.queue_free()
			
	for floor_key in floors:
		if FloorManager.floor_positions.has(floor_key):
			var btn = Button.new()
			var data = FloorManager.floor_positions[floor_key]
			btn.text = data.get("name", str(floor_key)) 
			
			btn.custom_minimum_size = Vector2(0, 60) 
			
			btn.add_theme_font_size_override("font_size", 24)
			
			btn.pressed.connect(Callable(self, "_on_floor_selected").bind(floor_key))
			vbox.add_child(btn)
			
	var cancel_btn = Button.new()
	cancel_btn.text = "UI_CANCEL"
	
	cancel_btn.custom_minimum_size = Vector2(0, 60)
	cancel_btn.add_theme_font_size_override("font_size", 24)
	
	cancel_btn.pressed.connect(Callable(self, "close_panel"))
	vbox.add_child(cancel_btn)

func _on_floor_selected(floor_key: String):
	var data = FloorManager.floor_positions[floor_key]
	
	FloorManager.target_position = data["position"]
	FloorManager.target_rotation = data["rotation"]
	
	var scene_name = floor_key.split("_")[0]
	var scene_path = "res://scenes/" + scene_name + ".tscn"
	
	close_panel()
	
	get_tree().get_first_node_in_group("player").is_warming_up = true
	
	var chunk_name = "chunk_" + scene_name
	ChunkManager.load_scene(chunk_name, scene_path)

func close_panel():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Signalbus.emit_signal("infopanel_closed")

func close_panel_force():
	hide()
