extends Control

@onready var GM = $"/root/GameManager"
@onready var UTILS = $"/root/Utils"

@onready var score_data: Label = $Holder/Score/ScoreData
@onready var high_score_data: Label = $Holder/HScore/HighScoreData
@onready var timer_label: Label = $Holder/Timer/TimerLabel

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_label.text = UTILS.parse_time_data(GM.TOTAL_SECONDS)
	score_data.text = str(GM.TRACKED["CLICKS"])

func _on_timer_timer_timeout() -> void:
	GM.TOTAL_SECONDS += 1
