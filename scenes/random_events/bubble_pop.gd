extends AnimatedSprite2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const bubble_pops := [
	preload("res://assets/sounds/sfx/bubble1.ogg"),
	preload("res://assets/sounds/sfx/bubble2.ogg")
	]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(global_position)
	scale = Vector2(2, 2)
	audio_stream_player_2d.stream = bubble_pops.pick_random()
	if audio_stream_player_2d.stream:
		audio_stream_player_2d.play()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
