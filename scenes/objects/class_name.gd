extends MeshInstance3D

@export var cl_name : String 

func _ready() -> void:
	var texture_path: String = "res://textures/class_names/%s.webp" % cl_name.to_lower()
	
	if ResourceLoader.exists(texture_path):
		var new_texture = load(texture_path)
		var orig_material = get_active_material(0)
		
		if orig_material is StandardMaterial3D:
			var unique_material = orig_material.duplicate()
			
			unique_material.albedo_texture = new_texture
			
			set_surface_override_material(0, unique_material)
		else:
			print("Ошибка: На объекте нет StandardMaterial3D или он пустой!")
	else:
		print("Файл не найден: ", texture_path)

func _process(delta: float) -> void:
	pass
