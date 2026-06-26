extends Node

@export var object_id: String = ""

func open_info_panel() -> void:
	if object_id == "":
		push_warning("InteractableObject3d: Не задан object_id в инспекторе!")
		return
	
	if InteractableObjects.ObjectsDB.has(object_id):
		var data = InteractableObjects.ObjectsDB[object_id]
		Signalbus.emit_signal("share_infodata", data)
	else:
		push_error("InteractableObject3d: Ключ '" + object_id + "' не найден в ObjectsDB.objects!")
	
