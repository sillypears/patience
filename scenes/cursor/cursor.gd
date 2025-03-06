extends AnimatedSprite2D

func _ready() -> void:
	play()
	var tim = Timer.new()
	var frames = self.sprite_frames.get_frame_count("click")
	var fps = self.sprite_frames.get_animation_speed("click")
	tim.wait_time = frames/fps
	tim.autostart = true
	tim.one_shot = true
	add_child(tim)
	tim.timeout.connect(_on_timer_timeout)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	queue_free()
