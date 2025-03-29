extends Node

const GAMEOVER = preload("res://scenes/gameover/gameover.tscn")

var TOTAL_SECONDS: int = 0
var CLICKS: int = 0
var BUBBLES_POPPED: int = 0
var HIGH_SCORE: int = 0
var MOUSE_TRAVELED: float = 0.0
var FISH_TOUCHED: int = 0

var RANDOM_EVENTS_DICT = {
	"travel": {
		"scene": "res://scenes/random_events/travel_display.tscn",
		"rarity": 10,
		"picked": 0
	},
	"finisher": {
		"scene": "res://scenes/random_events/finisher.tscn",
		"rarity": 10,
		"picked": 0
	},
	"trucks": {
		"scene": "res://scenes/random_events/truck_vroom.tscn",
		"rarity": 20,
		"picked": 0
	},
	"bubble": {
		"scene": "res://scenes/random_events/bubble.tscn",
		"rarity": 15,
		"picked": 0
	},
	"fish": {
		"scene": "res://scenes/random_events/fish.tscn",
		"rarity": 5,
		"picked": 0
	}
}

var RANDOM_EVENTS_LIST = [
	"travel",
	"finisher",
	"trucks",
	"bubble",
	"fish"
]

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("end_game"):
		print_debug("why'd you push that")
		SceneManager.change_scene("res://scenes/gameover/gameover.tscn")
		
func update_timer(seconds: int) -> void:
	TOTAL_SECONDS += seconds

func increase_picked_scene(scene: String) -> void:
	for x in RANDOM_EVENTS_DICT:
		if RANDOM_EVENTS_DICT[x].scene == scene:
			RANDOM_EVENTS_DICT[x].picked += 1

func reset_event_list() -> void:
	for x in RANDOM_EVENTS_LIST:
		x.picked = 0
