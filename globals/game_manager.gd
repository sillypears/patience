extends Node

const GAMEOVER = preload("res://scenes/gameover/gameover.tscn")

var TOTAL_SECONDS := 0
var HIGH_SCORE := 0

enum GAME_STATES { INTRO, MAIN, GAME, GAME_OVER, MENU } 
var GAME_STATE = GAME_STATES.INTRO

var TRACKED := {
	"CLICKS": 0,
	"BUBBLES_POPPED": 0,
	"MOUSE_TRAVELED": 0,
	"FISH_TOUCHED": 0
}

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
	print(typeof(TRACKED["CLICKS"]))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("end_game") or (Input.is_key_pressed(KEY_P) and Input.is_key_pressed(KEY_SHIFT)):
		print_debug("why'd you push that — end_game triggered")
		if SceneManager and SceneManager.has_method("change_scene"):
			SceneManager.change_scene("res://scenes/gameover/gameover.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/gameover/gameover.tscn")
		
func update_timer(seconds: int) -> void:
	TOTAL_SECONDS += seconds

func increase_picked_scene(scene: String) -> void:
	for x in RANDOM_EVENTS_DICT:
		if RANDOM_EVENTS_DICT[x].scene == scene:
			RANDOM_EVENTS_DICT[x].picked += 1

func reset_game() -> void:
	TOTAL_SECONDS = 0
	for x in TRACKED:
		if typeof(TRACKED[x]) == TYPE_INT:
			TRACKED[x] = 0
		if typeof(TRACKED[x]) == TYPE_FLOAT:
			TRACKED[x] = 0.0
		if typeof(TRACKED[x]) == TYPE_STRING:
			TRACKED[x] = ""

	reset_event_list()

func reset_event_list() -> void:
	for x in RANDOM_EVENTS_LIST:
		RANDOM_EVENTS_DICT[x].picked = 0

func build_discord_payload(player_name: String, player_email: String) -> Dictionary:
	# Discord webhook payload — content only, single CSV line for Sheets.
	# Order matches header: name,email,high_score,total_seconds,time_formatted,clicks,miles_moved,trucks_seen,miles_seen,bubbles_spawned,bubbles_popped,fish_spawned,fish_touched,finishers_shown,submitted_at,unix_time
	var data := build_payload(player_name, player_email)
	var stats: Dictionary = data["stats"]
	var tracked: Dictionary = stats.get("tracked", {})
	var events: Dictionary = stats.get("random_events", {})

	# Helper to safely stringify event counts
	var trucks: String = str(events.get("trucks", {}).get("picked", 0)) if events.has("trucks") else "0"
	var travel: String = str(events.get("travel", {}).get("picked", 0)) if events.has("travel") else "0"
	var bubbles: String = str(events.get("bubble", {}).get("picked", 0)) if events.has("bubble") else "0"
	var fish: String = str(events.get("fish", {}).get("picked", 0)) if events.has("fish") else "0"
	var finishers: String = str(events.get("finisher", {}).get("picked", 0)) if events.has("finisher") else "0"
	var clicks: String = str(tracked.get("CLICKS", 0))
	var popped: String = str(tracked.get("BUBBLES_POPPED", 0))
	var touched: String = str(tracked.get("FISH_TOUCHED", 0))
	var miles_moved: String = str(tracked.get("MOUSE_TRAVELED", 0))

	# Single CSV data line — no header, no JSON, no embed.
	# Highlight the Discord message → paste directly into Sheets/Excel.
	# Order: name,email,high_score,total_seconds,time_formatted,clicks,miles_moved,trucks_seen,miles_seen,bubbles_spawned,bubbles_popped,fish_spawned,fish_touched,finishers_shown,submitted_at,unix_time
	# Note: high_score stays 0 as a joke — not promoted from clicks.
	var parts := PackedStringArray([
		_csv_escape(player_name),
		_csv_escape(player_email),
		str(stats.get("high_score", 0)),
		str(stats.get("total_seconds", 0)),
		_csv_escape(stats.get("total_time_formatted", "")),
		clicks, miles_moved, trucks, travel, bubbles, popped, fish, touched, finishers,
		_csv_escape(data["meta"]["submitted_at"]),
		str(data["meta"]["unix_time"]),
	])
	var csv_row: String = ",".join(parts)

	return {
		"username": "Patience Simulator",
		# "avatar_url": "https://example.com/icon.png", # optional — uncomment and set
		"content": "```csv\n" + csv_row + "\n```",
	}
	
func _csv_escape(s: String) -> String:
	# RFC4180: wrap in quotes if contains comma, quote, or newline; double quotes inside.
	if "," in s or "\"" in s or "\n" in s:
		return "\"%s\"" % s.replace("\"", "\"\"")
	return s

func build_payload(player_name: String, player_email: String) -> Dictionary:
	# Single source of truth for stats. HIGH_SCORE intentionally stays 0 as a joke.

	var total_seconds: int = TOTAL_SECONDS if TOTAL_SECONDS else 0
	var high_score: int = HIGH_SCORE if HIGH_SCORE else 0
	# Duplicate to avoid mutating live tracked dict in payload.
	var tracked_copy := {}
	tracked_copy = TRACKED.duplicate()

	var events_copy := {}
	events_copy = RANDOM_EVENTS_DICT.duplicate(true)

	var time_str: String = ""
	var utils = get_node_or_null("/root/Utils")
	if utils and utils.has_method("parse_time_data"):
		time_str = utils.parse_time_data(total_seconds)

	return {
		"player": {
			"name": player_name,
			"email": player_email,
		},
		"score": high_score,
		"stats": {
			"high_score": high_score,
			"total_seconds": total_seconds,
			"total_time_formatted": time_str,
			"tracked": tracked_copy,
			"random_events": events_copy,
		},
		"meta": {
			"game": "Patience Simulator",
			"submitted_at": Time.get_datetime_string_from_system(false, true),
			"unix_time": Time.get_unix_time_from_system(),
		}
	}
