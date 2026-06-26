extends Node

@export var label_path : NodePath # Путь к текстовому узлу 
@onready var label = get_node(label_path) # Ссылка на текст интерфейса

# Вывод технического имени текущей панорамы в Label
func _process(delta):
	var pano_ctrl = get_parent().get_node("PanoramaController")
	if pano_ctrl:
		label.text = AvailablePanoramas.exit_map
