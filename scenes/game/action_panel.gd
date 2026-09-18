extends Panel

@onready var score_data: Label = $"ScoreData"

func _ready() -> void:
	score_data.resized.connect(_on_score_data_resized)
	#print_debug(custom_minimum_size)
	#print_debug(score_data.get_minimum_size())

func _process(delta: float) -> void:
	pass

func _on_score_data_resized() -> void:
	#print_debug("Growing")
	custom_minimum_size.x = score_data.get_minimum_size().x
	#print_debug(get_minimum_size())
