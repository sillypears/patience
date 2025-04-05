extends Control

@onready var GM = $"/root/GameManager"
@onready var score_data: Label = $Panel/ScoreData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_data.text = str(GM.TRACKED["CLICKS"])


func _on_score_data_item_rect_changed() -> void:
	pass # Replace with function body.
