extends Control

@onready var bubble_sprite: Sprite2D = $Area2D/BubbleSprite
@onready var screen_size = get_viewport_rect().size
@onready var sprite_size = bubble_sprite.texture.get_size() * scale
@onready var pop = preload("res://scenes/random_events/bubble_pop.tscn")

var velocity = Vector2()

func _ready() -> void:
	velocity = Vector2(randi_range(-100, 100), randi_range(-100, 100))
	var bubble_size = bubble_sprite.texture.get_size() * scale

	position.x = clamp(randi_range(0, screen_size.x), bubble_size.x / 2, screen_size.x - bubble_size.x / 2)
	position.y = clamp(randi_range(0, screen_size.y), bubble_size.y / 2, screen_size.y - bubble_size.y / 2)
	set_process_input(true)
	
func _process(delta: float) -> void:
	position += velocity * delta

	if position.x - sprite_size.x / 2 <= 0 or position.x + sprite_size.x / 2 >= screen_size.x:
		velocity.x *= -1
		
	if position.y - sprite_size.y / 2 <= 0 or position.y + sprite_size.y / 2 >= screen_size.y:
		velocity.y *= -1.1

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print('lol')
		if pop:
			var pop_instance = pop.instantiate()
			get_parent().add_child(pop_instance)
			pop_instance.position = global_position
		queue_free()

func _on_bubble_disappear_timeout() -> void:
	queue_free()
