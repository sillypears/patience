extends AnimatedSprite2D

@onready var screen_size = get_viewport_rect().size
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var GM = $"/root/GameManager"
@onready var touched: Label = $Touched

var ANGLE := randf_range(-1, 1)
var velocity = Vector2()
var fish_size = sprite_frames.get_frame_texture("default", 0).get_size() * scale
var touched_val := 0

func _ready() -> void:
	if touched_val == 0:
		touched.hide()
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
	position.x = clamp(randi_range(0, screen_size.x), fish_size.x / 2, screen_size.x - fish_size.x / 2)
	position.y = clamp(randi_range(0, screen_size.y), fish_size.y / 2, screen_size.y - fish_size.y / 2)
	rotate(ANGLE)
	velocity = Vector2(randi_range(-150, 150), randi_range(-150, 150))

	if position.x < screen_size.x/2:
		flip_h = true
		#velocity.x *= 

func _process(delta: float) -> void:
	position += velocity * delta

func _on_screen_exited() -> void:
	queue_free()


func _on_area_2d_mouse_entered() -> void:
	if touched_val > 0:
		touched.show()
		touched.text = str(touched_val)

func _on_area_2d_mouse_exited() -> void:
	touched_val += 1
	GM.FISH_TOUCHED += 1
	touched.hide()
	
