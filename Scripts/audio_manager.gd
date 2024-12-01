extends Node

@export var sound_effects_settings: Array[SoundEffect]
var sound_effects_dict: Dictionary = {}
@onready var music = %Music

func _ready():
	for sound in sound_effects_settings:
		sound_effects_dict[sound.type] = sound

func play_music(song: AudioStream, volume):
	if music.playing:
		music.stop()
	music.stream = song
	music.volume_db = volume
	music.play()

func play_effect(effect: SoundEffect.SoundType):
	if not sound_effects_dict.has(effect):
		return
	var stream = sound_effects_dict.get(effect) as SoundEffect
	stream.change_audio_count(1)
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(player)
	player.bus = Settings.AudioBus.keys()[Settings.AudioBus.Sounds]
	player.volume_db = stream.volume
	player.stream = stream.sound_effect
	player.finished.connect(stream.on_audio_finished)
	player.finished.connect(player.queue_free)
	player.play()

func play_effect_at(effect: SoundEffect.SoundType, location: Vector2):
	if not sound_effects_dict.has(effect):
		return
	var stream = sound_effects_dict.get(effect) as SoundEffect
	stream.change_audio_count(1)
	var player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	add_child(player)
	player.position = location
	player.bus = Settings.AudioBus.keys()[Settings.AudioBus.Sounds]
	player.volume_db = stream.volume
	player.stream = stream.sound_effect
	player.finished.connect(stream.on_audio_finished)
	player.finished.connect(player.queue_free)
	player.play()
