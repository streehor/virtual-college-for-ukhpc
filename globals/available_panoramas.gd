extends Node

var AvPano = {} # Активная карта панорам 
var exit_map : String # Сцена возврата в 3D-режим 
var exit_rotation: Vector3 = Vector3(0, 0, 0) # Поворот игрока при выходе 
var exit_position # Позиция игрока при выходе

# хранит углы отклонения в зависимости от выбранного направления

var dir_angles = {
	"forward": 0,
	"forward_left": 0,
	"left": 90,
	"back_left": 180,
	"back": 180,
	"back_right": 180,
	"right": -90,
	"forward_right": 0
}

# хранит название текстуры (её местоположение в карте), путь к текстуре, доступные переходы и поворот.

var akt_zal = {
	"center": {"texture":"res://textures/akt_zal/akt_zal_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"west_1",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""},
	"rotation": {"base_yaw": 0}
	},
	"west_1": {"texture":"res://textures/akt_zal/akt_zal_2.webp",
	"transitions":{
		"forward_left":"",
		"forward":"west_2",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"center",
		"back_right":""},
	"rotation": {"base_yaw": 90}
		},
	"west_2": {"texture":"res://textures/akt_zal/akt_zal_3.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"west_1",
		"back_right":""},
	"rotation": {"base_yaw": 90}
		}
}

var konf_zal = {
	"center": {"texture":"res://textures/konf_zal/konf_zal_1_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"east_1",
		"back_left":"",
		"back":"exit",
		"back_right":""},
	"rotation": {"base_yaw": 0}
		},
	"east_1": {"texture":"res://textures/konf_zal/konf_zal_2_2.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"",
		"back_right":"center"},
		"rotation": {"base_yaw": -90}
		}
}

var museum = {
	"center": {"texture":"res://textures/museum/museum.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"exit",
		"back":"",
		"back_right":""}}
}

var p101 = {
	"center": {"texture":"res://textures/p101/p101_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"",
		"back_right":"exit"}}
}

var p102 = {
	"center": {"texture":"res://textures/p102/p102_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"west_1",
		"back":"exit",
		"back_right":""},
		"rotation": {"base_yaw": 0}
		},
	"west_1": {"texture":"res://textures/p102/p102_2.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"center",
		"back_right":""},
		"rotation": {"base_yaw": 90}
		}
}

var p103a = {
	"center": {"texture":"res://textures/p103a/p103a_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"exit",
		"back":"",
		"back_right":""}}
}

var p108 = {
	"center": {"texture":"res://textures/p108/p108_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"exit",
		"back":"",
		"back_right":""}}
}

var p204 = {
	"center": {"texture":"res://textures/p204/p204_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"",
		"back_right":"exit"}}
}

var p205 = {
	"center": {"texture":"res://textures/p205/p205_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"exit",
		"back":"",
		"back_right":""}}
}

var p207 = {
	"center": {"texture":"res://textures/p207/p207_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"west_1",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""},
		"rotation": {"base_yaw": 0}
		},
	"west_1": {"texture":"res://textures/p207/p207_2.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"center",
		"back_right":""},
		"rotation": {"base_yaw": 90}
		}
}

var p208 = {
	"center": {"texture":"res://textures/p208/p208_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"west_1",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""},
		"rotation": {"base_yaw": 0}
		},
	"west_1": {"texture":"res://textures/p208/p208_2.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"center",
		"back":"",
		"back_right":""},
		"rotation": {"base_yaw": 90}
		}
}

var p209 = {
	"center": {"texture":"res://textures/p209/p209_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p210 = {
	"center": {"texture":"res://textures/p210/p210_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"east_1",
		"back_left":"",
		"back":"exit",
		"back_right":""},
		"rotation": {"base_yaw": 0}
		},
	"east_1": {"texture":"res://textures/p210/p210_2.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"center",
		"back_right":""},
		"rotation": {"base_yaw": -90}
		}
}

var p212 = {
	"center": {"texture":"res://textures/p212/p212_2.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p213 = {
	"center": {"texture":"res://textures/p213/p213_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"exit",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"",
		"back_right":""}}
}

var p214 = {
	"center": {"texture":"res://textures/p214/p214_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"west_1",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""},
		"rotation": {"base_yaw": 0}
		},
	"west_1": {"texture":"res://textures/p214/p214_2.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"center",
		"back":"",
		"back_right":""},
		"rotation": {"base_yaw": 90}
		}
}

var u201 = {
	"center": {"texture":"res://textures/u201/u201_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u202 = {
	"center": {"texture":"res://textures/u202/u202_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u208 = {
	"center": {"texture":"res://textures/u208/u208_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"east_1",
		"back_left":"",
		"back":"exit",
		"back_right":""},
		"rotation": {"base_yaw": 0}
		},
	"east_1": {"texture":"res://textures/u208/u208_2.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"center",
		"back_right":""},
		"rotation": {"base_yaw": -90}
		}
}

var u210 = {
	"center": {"texture":"res://textures/u210/u210_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u301 = {
	"center": {"texture":"res://textures/u301/u301_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u302 = {
	"center": {"texture":"res://textures/u302/u302_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u303 = {
	"center": {"texture":"res://textures/u303/u303_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u304 = {
	"center": {"texture":"res://textures/u304/u304_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u305 = {
	"center": {"texture":"res://textures/u305/u305_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u306 = {
	"center": {"texture":"res://textures/u306/u306_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u308 = {
	"center": {"texture":"res://textures/u308/u308_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u309 = {
	"center": {"texture":"res://textures/u309/u309_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p301 = {
	"center": {"texture":"res://textures/p301/p301_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p302 = {
	"center": {"texture":"res://textures/p302/p302_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p303 = {
	"center": {"texture":"res://textures/p303/p303_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p304 = {
	"center": {"texture":"res://textures/p304/p304_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p305 = {
	"center": {"texture":"res://textures/p305/p305_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p307 = {
	"center": {"texture":"res://textures/p307/p307_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p308 = {
	"center": {"texture":"res://textures/p308/p308_1.png",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p309 = {
	"center": {"texture":"res://textures/p309/p309_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p311 = {
	"center": {"texture":"res://textures/p311/p311_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p312 = {
	"center": {"texture":"res://textures/p312/p312_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var p314 = {
	"center": {"texture":"res://textures/p314/p314_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u401 = {
	"center": {"texture":"res://textures/u401/u401_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u402 = {
	"center": {"texture":"res://textures/u402/u402_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u403 = {
	"center": {"texture":"res://textures/u403/u403_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u404 = {
	"center": {"texture":"res://textures/u404/u404_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u405 = {
	"center": {"texture":"res://textures/u405/u405_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u407 = {
	"center": {"texture":"res://textures/u407/u407_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

var u408 = {
	"center": {"texture":"res://textures/u408/u408_1.webp",
	"transitions":{
		"forward_left":"",
		"forward":"",
		"forward_right":"",
		"left":"",
		"right":"",
		"back_left":"",
		"back":"exit",
		"back_right":""}}
}

# хранит названия карт, для использования в коде

var MapLibrary = {
	"akt_zal": akt_zal,
	"konf_zal": konf_zal,
	"museum": museum,
	"p101": p101,
	"p102": p102,
	"p103a": p103a,
	"p108": p108,
	"p204": p204,
	"p205": p205,
	"p207": p207,
	"p208": p208,
	"p209": p209,
	"p210": p210,
	"p212": p212,
	"p213": p213,
	"p214": p214,
	"p301": p301,
	"p302": p302,
	"p303": p303,
	"p304": p304,
	"p305": p305,
	"p307": p307,
	"p308": p308,
	"p309": p309,
	"p311": p311,
	"p312": p312,
	"p314": p314,
	"u201": u201,
	"u202": u202,
	"u208": u208,
	"u210": u210,
	"u301": u301,
	"u302": u302,
	"u303": u303,
	"u304": u304,
	"u305": u305,
	"u306": u306,
	"u308": u308,
	"u309": u309,
	"u401": u401,
	"u402": u402,
	"u403": u403,
	"u404": u404,
	"u405": u405,
	"u407": u407,
	"u408": u408
}

func _ready() -> void:
	AvPano = akt_zal
