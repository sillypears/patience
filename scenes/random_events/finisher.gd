extends Control

@onready var finish_button: Button = $FinishButton
@onready var button_timer: Timer = $ButtonTimer
const GAMEOVER = preload("res://scenes/gameover/gameover.tscn")

func _ready() -> void:
	var mouser := get_local_mouse_position()
	finish_button.position.x = mouser.x + randi_range(-20, 20)
	finish_button.position.y = mouser.y + randi_range(-20, 20)
	print(finish_button.position)

func _process(delta: float) -> void:
	pass


func _on_finish_button_pressed() -> void:
	print("lol")
	get_tree().change_scene_to_packed(GAMEOVER)

func _on_button_timer_timeout() -> void:
	queue_free()
