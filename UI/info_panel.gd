extends Control

@onready var texture_rect = $Panel/TextureRect # Ссылка на иконку объекта 
@onready var title_label = $Panel/Label # Ссылка на заголовок 
@onready var description_label = $Panel/ScrollContainer/RichTextLabel # Ссылка на текст описания

# Скрытие интерфейса при запуске и подписка на получение данных
func _ready():
	self.visible = false
	Signalbus.connect("share_infodata", show_object)
	Signalbus.connect("toggle_pause_menu", toggle_pause_menu)

# Заполнение элементов UI, динамический расчет шрифта и открытие панели
func show_object(data: Dictionary):
	Signalbus.emit_signal("infopanel_opened")
	texture_rect.texture = load(data["image"])
	
	var translated_title = tr(data["title"])
	var translated_desc = tr(data["description"])
	
	description_label.text = translated_desc
	
	var size = 60
	var length = translated_title.length()
	
	if length > 25:
		size = 48
	if length > 35:
		size = 45
	if length > 45:
		size = 43
	
	title_label.text = "[font_size=%d][b]%s[/b][/font_size]" % [size, translated_title]
	
	self.visible = true

# Перевод панели в невидимое состояние
func hide_panel():
	self.visible = false

# Закрытие панели кнопкой и отправка сигнала разблокировки
func _on_button_pressed() -> void:
	Signalbus.emit_signal("infopanel_closed")
	hide_panel()

func toggle_pause_menu():
	Signalbus.emit_signal("infopanel_closed")
	hide_panel()
