extends Control

@onready var GM = $"/root/GameManager"
@onready var scaler: Timer = $Scaler
@onready var title: Label = $Margin/BoxContainer/Vbox/Title

func _ready() -> void:
	GM.GAME_STATE = GM.GAME_STATES.MAIN
	await get_tree().process_frame
	title.pivot_offset = title.size / 2
	
func _process(delta: float) -> void:
	var scale_factor = 1.0 + sin(Time.get_ticks_msec() / 1000.0 * 1.5) * 0.1
	title.scale = Vector2.ONE * scale_factor
		
func _on_scaler_timeout() -> void:
	title.scale = Vector2(1, 1)


func _on_start_pressed() -> void:
	var t = Timer.new()
	t.wait_time = 0.75
	t.timeout.connect(_go_to_game)
	add_child(t)
	t.start()
	
func _go_to_game() -> void:
	SceneManager.change_scene("res://scenes/game/game.tscn")
	
