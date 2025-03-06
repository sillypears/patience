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
	score_data.text = str(GM.CLICKS)

func _on_timer_timer_timeout() -> void:
	GM.TOTAL_SECONDS += 1
#
#func parse_time_data() -> String:
	#var seconds: int = GM.TOTAL_SECONDS % 60
	#var minutes: int = (GM.TOTAL_SECONDS % 3600) / 60
	#var hours: int = GM.TOTAL_SECONDS / 3600
	#var days: int = GM.TOTAL_SECONDS / 86400
#
	#var f_seconds := "%02d" % seconds
	#var f_minutes := "%02d" % minutes
	#var f_hours := "%02d" % hours
	#var f_days := "%02d" % days
#
	#var f_time = "{day}{hour}{min}:{sec}"
	#var formatter_things = {
		#"sec": f_seconds,
		#"min": f_minutes,
		#"hour": (f_hours+":") if hours > 0 else "",
		#"day": (f_days+":") if days > 0 else ""
	#}
#
	#return f_time.format(formatter_things)
