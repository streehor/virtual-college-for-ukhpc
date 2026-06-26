extends Label

func _ready() -> void:
	text = ""
	
	if ChunkManager.has_signal("load_progress_updated"):
		ChunkManager.load_progress_updated.connect(_on_progress)

func _on_progress(progress_text: String) -> void:
	if OS.has_feature("web"):
		text = progress_text
