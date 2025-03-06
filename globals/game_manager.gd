extends Node

const GAMEOVER = preload("res://scenes/gameover/gameover.tscn")

var TOTAL_SECONDS: int = 0
var CLICKS: int = 0
var HIGH_SCORE: int = 0
var MOUSE_TRAVELED: float = 0.0

var RANDOM_EVENTS_DICT = {
	"travel": {
		"scene": "res://scenes/random_events/travel_display.tscn",
		"rarity": 10,
		"picked": 0
	},
	"finisher": {
		"scene": "res://scenes/random_events/finisher.tscn",
		"rarity": 100,
		"picked": 0
	},
	"trucks": {
		"scene": "res://scenes/random_events/truck_vroom.tscn",
		"rarity": 20,
		"picked": 0
	}
}

var RANDOM_EVENTS_LIST = [
	"travel",
	"finisher",
	"trucks"
]

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	pass

func update_timer(seconds: int) -> void:
	TOTAL_SECONDS += seconds

func increase_picked_scene(scene: String) -> void:
	for x in RANDOM_EVENTS_DICT:
		if RANDOM_EVENTS_DICT[x].scene == scene:
			RANDOM_EVENTS_DICT[x].picked += 1

func reset_event_list() -> void:
	for x in RANDOM_EVENTS_LIST:
		x.picked = 0
