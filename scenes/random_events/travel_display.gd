extends Control

@onready var GM = $"/root/GameManager"
@onready var travel_label_data: Label = $TravelLabelData


func _ready() -> void:
	travel_label_data.text = str(GM.TRACKED["MOUSE_TRAVELED"])
	travel_label_data.position = get_local_mouse_position()
	#.Input.get_vector()
	
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	queue_free()
