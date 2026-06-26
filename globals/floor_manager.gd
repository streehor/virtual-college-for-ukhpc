extends Node

var target_position = null
var target_rotation = null

var last_floor = null

var floor_positions = {
	"u100_left": {
		"name": "U_FLOOR_1",
		"position": Vector3(0.0, 0.564, 10.647),
		"rotation": -90.0
	},
	
	"u100_center": {
		"name": "U_FLOOR_1",
		"position": Vector3(7.493, 0.564, -2.652),
		"rotation": 90.0
	},
	
	"u100_right": {
		"name": "U_FLOOR_1",
		"position": Vector3(0.0, 0.564, -9.678),
		"rotation": -90.0
	},
	"u200_right": {
		"name": "U_FLOOR_2",
		"position": Vector3(0.0, 0.564, 6.238),
		"rotation": 90.0
	},
	"u200_center": {
		"name": "U_FLOOR_2",
		"position": Vector3(7.974, 0.564, -2.288),
		"rotation": 90.0
	},
	"u200_left": {
		"name": "U_FLOOR_2",
		"position": Vector3(0.0, 0.564, -7.796),
		"rotation": 90.0
	},
	"u300_right": {
		"name": "U_FLOOR_3",
		"position": Vector3(0.0, 0.564, 6.227),
		"rotation": 90.0
	},
	"u300_left": {
		"name": "U_FLOOR_3",
		"position": Vector3(0.0, 0.564, -12.894),
		"rotation": 90.0
	},
	"u400_right": {
		"name": "U_FLOOR_4",
		"position": Vector3(0.0, 0.564, 6.234),
		"rotation": 90.0
	},
	"u400_left": {
		"name": "U_FLOOR_4",
		"position": Vector3(0.0, 0.564, -7.834),
		"rotation": 90.0
	},
	"p100_left": {
		"name": "P_FLOOR_1",
		"position": Vector3(0.0, 0.564, 10.749),
		"rotation": -90.0
	},
	"p100_right": {
		"name": "P_FLOOR_1",
		"position": Vector3(0.0, 0.564, -10.17),
		"rotation": -90.0
	},
	"p200_left": {
		"name": "P_FLOOR_2",
		"position": Vector3(0.0, 0.564, 9.247),
		"rotation": -90.0
	},
	"p200_center": {
		"name": "P_FLOOR_2",
		"position": Vector3(5.005, 0.564, 2.991),
		"rotation": 90.0
	},
	"p200_right": {
		"name": "P_FLOOR_2",
		"position": Vector3(0.0, 0.564, -8.544),
		"rotation": -90.0
	},
	"p300_left": {
		"name": "P_FLOOR_3",
		"position": Vector3(0.0, 0.564, 9.235),
		"rotation": -90.0
	},
	"p300_right": {
		"name": "P_FLOOR_3",
		"position": Vector3(0.0, 0.564, -13.389),
		"rotation": -90.0
	}
}

func _ready() -> void:
	last_floor = floor_positions["u100_center"]
	target_position = floor_positions["u100_center"]["position"]
	target_rotation = floor_positions["u100_center"]["rotation"]
