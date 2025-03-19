extends Control

@onready var GM = $"/root/GameManager"
@onready var touch_screen_button: TouchScreenButton = $TouchScreenButton

@export var cursor_anim : PackedScene 

@export var prize_value: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GM.TOTAL_SECONDS += 1

func _input(event) -> void:
	if event is InputEventMouseButton or touch_screen_button.is_pressed():
		var picked = GM.RANDOM_EVENTS_LIST.pick_random()
		if randi() % GM.RANDOM_EVENTS_DICT[picked].rarity == 0:
			print("It's random! " + GM.RANDOM_EVENTS_DICT[picked].scene)
			GM.increase_picked_scene(GM.RANDOM_EVENTS_DICT[picked].scene)

			var rando_event = load(GM.RANDOM_EVENTS_DICT[picked].scene)
			if rando_event:
				var nodes_in_group = get_tree().get_nodes_in_group("Finisher")
				if len(nodes_in_group) > 0: 
					return
				var rando_instance = rando_event.instantiate()
				get_groups()
				add_child(rando_instance)

	if touch_screen_button.is_pressed():
		GM.CLICKS += prize_value
		var animated_cursor = cursor_anim.instantiate()
		animated_cursor.position = event.position
		add_child(animated_cursor)
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			GM.CLICKS += prize_value
			var animated_cursor = cursor_anim.instantiate()
			animated_cursor.position = event.position
			add_child(animated_cursor)
