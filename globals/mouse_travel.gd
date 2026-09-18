extends Node

@onready var GM = $"/root/GameManager"
var previous_mouse_position: Vector2 = Vector2.ZERO
var total_mouse_distance: float = 0.0
var is_window_focused: bool = true

func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		is_window_focused = true
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		is_window_focused = false

func _ready() -> void:
	previous_mouse_position = get_viewport().get_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_window_focused:
		return
	if GM.GAME_STATE == GM.GAME_STATES.GAME:
		var current_mouse_position = get_viewport().get_mouse_position()
		var window_size = DisplayServer.window_get_size()
		if current_mouse_position.x < 0 or current_mouse_position.x > window_size.x or current_mouse_position.y < 0 or current_mouse_position.y > window_size.y:
			return
		
		var distance_moved = current_mouse_position.distance_to(previous_mouse_position)
		GM.TRACKED["MOUSE_TRAVELED"] += int((total_mouse_distance ) + distance_moved / 100)
		previous_mouse_position = current_mouse_position
