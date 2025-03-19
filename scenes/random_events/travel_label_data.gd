extends Label

@onready var GM = $"/root/GameManager"

var text_scaler: float = 1.0 + ((randi() % 20)/20.0)
const text_fader: float = 1.0

func _ready() -> void:
	pivot_offset = size / 2
	position -= size/2
	#print_debug("Number " + str(GM.MOUSE_TRAVELED) + " growing at " + str(text_scaler))
	self_modulate.r8 = randi() % 255
	self_modulate.g8 = randi() % 255
	self.modulate.b8 = randi() % 255

func _process(delta: float) -> void:
	modulate.a -= text_fader * delta
	modulate.a = clamp(modulate.a, 0.25, 1.0)
	scale += Vector2(text_scaler/2, text_scaler/2) * delta
