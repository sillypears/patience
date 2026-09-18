extends AnimatedSprite2D

@onready var SM = $"/root/SoundManager"
@export var speed: float = 100.0
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var direction: int
var screen_width : int
var screen_height : int
var my_width
var angle : float
const TRUCK_MOVING = preload("res://assets/sounds/sfx/truck_moving.ogg")

var audioplayerlol: AudioStreamPlayer
var audioplayerplaying: bool = false

func _ready():
	add_to_group("TruckSounds")
	screen_width = ProjectSettings.get("display/window/size/viewport_width")
	screen_height = ProjectSettings.get("display/window/size/viewport_height")

	my_width = sprite_frames.get_frame_texture(animation, frame).get_size().x
	
	var start_from_left = randi() % 2 == 0
	direction = -1 if start_from_left else 1
	if not start_from_left:
		position = Vector2(0, randf() * screen_height)
	else:
		position = Vector2(screen_width, randf() * screen_height)
	angle = deg_to_rad(randf_range(-15, 15))
	if start_from_left:
		flip_h = true
	speed += randi() % 150
	play()
	if len(get_tree().get_nodes_in_group("TruckSounds")) <= 1:
		audioplayerlol = SM.play_sfx(load("res://assets/sounds/sfx/truck_moving.ogg"), "TruckSounds", self, true)

func _process(delta):
	position.x += speed * direction * delta
	if direction == 1 and position.x > screen_width+my_width:
		remove_from_group("TruckSounds")
		queue_free()
		audioplayerplaying = true
	elif direction == -1 and position.x < 0-my_width:
		remove_from_group("TruckSounds")
		queue_free()
		audioplayerplaying = true
