extends Control

@onready var GM = $"/root/GameManager"
const WORD1 := "MADE"
const WORD2 := "WITH"
const WORD3 := "AI"
var WORDS = "MADE WITH\nCONNECTIVE TISSUE OF\nSENTIENT AI LIFEFORMS"
var WORD_COUNTER = 0

@onready var ai: Label = $Margin/Box/BoxTop/AI
@onready var timer: Timer = $Timer
@onready var timer2: Timer = $Timer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GM.GAME_STATE = GM.GAME_STATES.INTRO
	timer.wait_time = 0.1
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if WORD_COUNTER >= len(WORDS):
		timer.stop()
		set_process(false)
		timer2.start()

func _on_timer_timeout() -> void:
	ai.text += WORDS[WORD_COUNTER]
	WORD_COUNTER += 1


func _on_timer_2_timeout() -> void:
	var sm = get_node_or_null("/root/SceneManager")
	if sm and sm.has_method("change_scene"):
		sm.change_scene("res://scenes/main/main.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
