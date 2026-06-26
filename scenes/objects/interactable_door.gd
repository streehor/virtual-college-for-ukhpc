extends MeshInstance3D

@export var target_scene_path: String = "" # Путь к 3D-сцене
@onready var door_collider = $door_collider # Коллайдер
@export var id : String # ID карты панорам
@export var exit_coord : Vector3 # Координаты возврата
@export var exit_rotation : Vector3 # Поворот возврата
@export var source_map: String # Путь текущей сцены

func _ready():
	Signalbus.connect("door_clicked", Callable(self, "_on_door_clicked"))

func _on_door_clicked(collider):
	if collider == door_collider:
		if target_scene_path != "":
			AvailablePanoramas.exit_position = exit_coord
			AvailablePanoramas.exit_rotation = exit_rotation
			AvailablePanoramas.exit_map = source_map
			AvailablePanoramas.AvPano = AvailablePanoramas.MapLibrary.get(id, {})
			
			get_tree().get_first_node_in_group("player").is_warming_up = true
			
			var chunk_name = "chunk_" + id 
			ChunkManager.load_scene(chunk_name, target_scene_path)
