extends Node

## Enum that defines the Audio buses on the audio tab in the same order
## It's important to keep the order for the correct behaviour
enum AudioBus {Main, Sounds, Music }
signal _music_volume_changed(new_volume: float)
signal _sounds_volume_changed(new_volume: float)

func _ready():
	_music_volume_changed.connect(_on_music_volume_changed)
	_sounds_volume_changed.connect(_on_sound__volume_changed)

## Change the volume for the Music audio bus
func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioBus.Music, 	linear_to_db(value))

## Change the volume for the Sounds audio bus
func _on_sound__volume_changed(value):
	AudioServer.set_bus_volume_db(AudioBus.Sounds, 	linear_to_db(value))
