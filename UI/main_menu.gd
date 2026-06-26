extends Node2D

var is_tutor_opened = false
@onready var bg = $bg

const TUTORIAL_RU = """[font_size=40][center][b][color=#2dd4bf]ДОБРО ПОЖАЛОВАТЬ В ВИРТУАЛЬНЫЙ ТУР![/color][/b][/center]

[b][color=#94a3b8]В КОРИДОРАХ (3D-РЕЖИМ)[/color][/b]
[ul]
[b]W, A, S, D[/b] — Перемещение по зданию.
[b]Shift[/b] — Ускоренный шаг.
[b]Мышь[/b] — Осмотр вокруг.
[b]ЛКМ по двери[/b] — Войти в кабинет или сменить этаж.
[b]P, ESC[/b] - Пауза.
[/ul]

[b][color=#94a3b8]В КАБИНЕТАХ (РЕЖИМ ПАНОРАМ)[/color][/b]
[ul]
[b]Мышь[/b] — Осмотр помещения на 360 градусов.
[b]ЛКМ по прозрачным стрелкам[/b] — Шаг в другую точку комнаты.
[b]ЛКМ по подсвеченным зонам[/b] — Открыть информацию об объекте.
[b]Клик по стрелке выхода[/b] — Вернуться в коридор.
[b]P, ESC[/b] - Пауза.
[/ul][/font_size]"""

const TUTORIAL_KK = """[font_size=40][center][b][color=#2dd4bf]ВИРТУАЛДЫ ТУРҒА ҚОШ КЕЛДІҢІЗДЕР![/color][/b][/center]

[b][color=#94a3b8]ДӘЛІЗДЕРДЕ (3D-РЕЖИМ)[/color][/b]
[ul]
[b]W, A, S, D[/b] — Ғимарат ішінде қозғалу.
[b]Shift[/b] — Жылдамдатылған қадам.
[b]Тінтуір[/b] — Айналаға көз салу.
[b]Есікті сол жақ батырмамен шерту[/b] — Кабинетке кіру немесе қабатты ауыстыру.
[b]P, ESC[/b] - Үзіліс.
[/ul]

[b][color=#94a3b8]КАБИНЕТТЕРДЕ (ПАНОРАМА РЕЖИМІ)[/color][/b]
[ul]
[b]Тінтуір[/b] — Бөлмені 360 градусқа шолу.
[b]Мөлдір көрсеткіштерді сол жақ батырмамен шерту[/b] — Бөлменің басқа нүктесіне өту.
[b]Бөлінген аймақтарды сол жақ батырмамен шерту[/b] - Нысан туралы ақпаратты ашу.
[b]Шығу есігін шерту[/b] — Дәлізге қайта оралу.
[b]P, ESC[/b] - Үзіліс.
[/ul][/font_size]"""

func _ready() -> void:
	$tutorial.hide()
	$menu.show()
	TranslationServer.set_locale("ru")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_ui_language()
	animate_background()
	 
	if OS.has_feature("web"):
		$menu/quit.hide()
	else:
		$menu/quit.show()

func _on_start_pressed() -> void:
	$menu/start.disabled = true
	$menu/tutor.disabled = true
	$menu/quit.disabled = true
	$lang.disabled = true
	$fullscreen.disabled = true
	
	ChunkManager.load_scene("chunk_u100", "res://scenes/u100.tscn")

func _on_lang_pressed() -> void:
	if Signalbus.current_lang == "ru":
		Signalbus.current_lang = "kk"
		TranslationServer.set_locale("kk")
	else:
		Signalbus.current_lang = "ru"
		TranslationServer.set_locale("ru")
	update_ui_language()

func _on_tutor_pressed() -> void:
	$tutorial.show()
	$menu.hide()

func update_ui_language():
	if Signalbus.current_lang == "ru":
		$tutorial/RichTextLabel.text = TUTORIAL_RU
	else:
		$tutorial/RichTextLabel.text = TUTORIAL_KK


func _on_back_pressed() -> void:
	$tutorial.hide()
	$menu.show()

func animate_background() -> void:
	var shift_amount = 300.0
	var duration = 20.0
	
	var start_x = bg.position.x
	var tween = create_tween().set_loops()
	
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(bg, "position:x", start_x - shift_amount, duration)
	tween.tween_property(bg, "position:x", start_x, duration)


func _on_fullscreen_pressed() -> void:
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_quit_pressed() -> void:
	get_tree().quit()
