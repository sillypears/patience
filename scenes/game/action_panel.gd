extends Panel

@onready var score_data: Label = $"ScoreData"

func _ready() -> void:
	score_data.resized.connect(_on_score_data_resized)
	#print(custom_minimum_size)
	#print(score_data.get_minimum_size())

func _process(delta: float) -> void:
	pass

func _on_score_data_resized() -> void:
	#print("Growing")
	custom_minimum_size.x = score_data.get_minimum_size().x
	#print(get_minimum_size())
