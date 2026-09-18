extends Control

@onready var finish_button: Button = $FinishButton
@onready var button_timer: Timer = $ButtonTimer


const GAMEOVER := preload("res://scenes/gameover/gameover.tscn")

func _ready() -> void:
	var mouser := get_local_mouse_position()
	finish_button.position.x = mouser.x + randi_range(-20, 20)
	finish_button.position.y = mouser.y + randi_range(-20, 20)
	print_debug(finish_button.position)
	
func _process(delta: float) -> void:
	pass


func _on_finish_button_pressed() -> void:
	print_debug("Finisher pressed — changing to gameover")
	# SceneManager can fail in HTML5 if transition shaders aren't ready; fallback to tree change
	if SceneManager and SceneManager.has_method("change_scene"):
		SceneManager.change_scene("res://scenes/gameover/gameover.tscn", {"animation_name_enter": "fade", "pattern_leave": "radial"})
	else:
		get_tree().change_scene_to_packed(GAMEOVER)
	# Safety fallback if SceneManager doesn't switch within a frame (e.g. web)
	await get_tree().create_timer(0.5).timeout
	if get_tree().current_scene and get_tree().current_scene.name != "Gameover":
		print_debug("SceneManager didn't switch — fallback to change_scene_to_file")
		get_tree().change_scene_to_file("res://scenes/gameover/gameover.tscn")

func _on_button_timer_timeout() -> void:
	queue_free()
