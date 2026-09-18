extends Node

@export var music_volume: float = 1.0
@export var sfx_volume: float = 0.25

var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	# Add audio players as children
	add_child(music_player)
	add_child(sfx_player)

func play_music(stream: AudioStream, loop: bool = true):
	if music_player.stream != stream:
		music_player.stop()
		music_player.stream = stream
	music_player.volume_db = linear_to_db(music_volume)
	#music_player.loop = loop
	music_player.play()

func stop_music():
	music_player.stop()

func play_sfx(stream: AudioStream, group: String, node: Node, looper: bool = false) -> AudioStreamPlayer:
	var temp_player = AudioStreamPlayer.new()
	node.add_child(temp_player, true)  # Temporary node for one-time sound effects
	temp_player.stream = stream
	temp_player.stream.loop = looper
	temp_player.volume_db = linear_to_db(sfx_volume)
	temp_player.play()
	return temp_player

func set_music_volume(volume: float):
	music_volume = volume
	music_player.volume_db = linear_to_db(volume)
	
func set_sfx_volume(volume: float):
	sfx_volume = volume
