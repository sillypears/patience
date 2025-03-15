extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
