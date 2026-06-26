extends Node3D

@onready var door_collider = $model/door_collider
@export var available_floors : Array[String]

func _ready() -> void:
	Signalbus.connect("door_clicked", Callable(self, "_on_door_clicked"))


func _on_door_clicked(collider):
	if collider == door_collider:
		if available_floors.size() > 0:
			Signalbus.emit_signal("open_floor_panel", available_floors)
		else:
			print("Нет доступных этажей для этой двери")
