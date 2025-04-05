extends Control

@onready var GM = $"/root/GameManager"
@onready var UTILS = $"/root/Utils"

# Values to update
@onready var high_score_value: Label = $Contain/Vbox/Sep/BoxTop/RIGHT/RightStuffHolder/HighScoreValue
@onready var total_time_value: Label = $Contain/Vbox/Sep/BoxTop/RIGHT/RightStuffHolder/TotalTimeValue

@onready var total_clicks_value: Label = $Contain/Vbox/Sep/BoxBot/RIGHT/RightStuffHolder/TotalClicksValue
@onready var mouse_traveled_value: Label = $Contain/Vbox/Sep/BoxBot/RIGHT/RightStuffHolder/MouseTraveledValue
@onready var trucks_seen_value: Label = $Contain/Vbox/Sep/BoxBot/RIGHT/RightStuffHolder/TrucksSeenValue
@onready var miles_displayed_value: Label = $Contain/Vbox/Sep/BoxBot/RIGHT/RightStuffHolder/MilesDisplayedValue
@onready var bubbles_spawned_value: Label = $Contain/Vbox/Sep/BoxBot/RIGHT/RightStuffHolder/BubblesSpawnedValue
@onready var bubbles_popped_value: Label = $Contain/Vbox/Sep/BoxBot/RIGHT/RightStuffHolder/BubblesPoppedValue
@onready var fish_seen_value: Label = $Contain/Vbox/Sep/BoxBot/RIGHT/RightStuffHolder/FishSeenVal
@onready var fish_touched_value: Label = $Contain/Vbox/Sep/BoxBot/RIGHT/RightStuffHolder/FishTouchedVal

func _ready() -> void:
	GM.GAME_STATE = GM.GAME_STATES.GAME_OVER
	high_score_value.text = str(GM.HIGH_SCORE)
	total_time_value.text = UTILS.parse_time_data(GM.TOTAL_SECONDS)
	total_clicks_value.text = str(GM.TRACKED["CLICKS"])
	mouse_traveled_value.text = str(GM.TRACKED["MOUSE_TRAVELED"]) + " MILES"
	trucks_seen_value.text = str(GM.RANDOM_EVENTS_DICT["trucks"].picked)
	miles_displayed_value.text = str(GM.RANDOM_EVENTS_DICT["travel"].picked)
	bubbles_spawned_value.text = str(GM.RANDOM_EVENTS_DICT["bubble"].picked)
	bubbles_popped_value.text = str(GM.TRACKED["BUBBLES_POPPED"])
	fish_seen_value.text = str(GM.RANDOM_EVENTS_DICT["fish"].picked)
	fish_touched_value.text = str(GM.TRACKED["FISH_TOUCHED"])

func _process(delta: float) -> void:
	pass


func _on_try_again_pressed() -> void:
	GM.reset_game()
	SceneManager.change_scene("res://scenes/game/game.tscn")
