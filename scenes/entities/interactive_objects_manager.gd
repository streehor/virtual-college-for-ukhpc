extends Node

@export var interactable_zone_scene: PackedScene # Сцена интерактивного триггера

# Массивы пула
var pool: Array = []
var active_objects: Array = []

# Сколько объектов предсоздать при старте (укажи максимум для одной панорамы)
const POOL_SIZE = 15 

func _ready():
	if interactable_zone_scene == null:
		push_error("Interactable zone scene не задана!")
		return
		
	# Забиваем склад выключенными объектами
	for i in range(POOL_SIZE):
		var zone = interactable_zone_scene.instantiate()
		add_child(zone)
		zone.visible = false
		zone.process_mode = Node.PROCESS_MODE_DISABLED
		pool.append(zone)

# Спавн интерактивных зон по имени текстуры
func spawn_objects(texture_path: String):
	var texture_name = texture_path.get_file()
	if not InteractableObjects.InteractiveMap.has(texture_name):
		print("Нет интерактивных объектов для ", texture_name)
		return
	
	for obj_data in InteractableObjects.InteractiveMap[texture_name]:
		if pool.is_empty():
			push_error("Нехватка объектов в пуле! Увеличьте POOL_SIZE.")
			break
			
		var zone = pool.pop_back()
		
		zone.name = obj_data["name"]
		zone.position = obj_data["position"]
		zone.scale = Vector3(obj_data["size"].x, obj_data["size"].y, 0.01)
		
		if obj_data.has("rotation"):
			zone.rotation_degrees = obj_data["rotation"]
		else:
			zone.rotation_degrees = Vector3.ZERO
			
		zone.object_type = obj_data["type"]
		
		# Включаем и добавляем в список активных
		zone.visible = true
		zone.process_mode = Node.PROCESS_MODE_INHERIT
		active_objects.append(zone)

# Удаление (возврат в пул) всех триггеров на сцене
func reset_objects() -> void:
	for zone in active_objects:
		zone.visible = false
		zone.process_mode = Node.PROCESS_MODE_DISABLED
		pool.append(zone)
		
	active_objects.clear()
