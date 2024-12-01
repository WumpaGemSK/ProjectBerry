extends Node

## Enum that defines the Audio buses on the audio tab in the same order
## It's important to keep the order for the correct behaviour
enum AudioBus {Main, Sounds, Music }
signal _music_volume_changed(new_volume: float)
signal _sounds_volume_changed(new_volume: float)
signal _viewport_change_size(factor: float)

## Connect the Settings change signal to the appropiate function
func _ready():
	_music_volume_changed.connect(_on_music_volume_changed)
	_sounds_volume_changed.connect(_on_sound__volume_changed)
	_viewport_change_size.connect(viewport_change_size)

## Change the volume for the Music audio bus
func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioBus.Music, 	linear_to_db(value))

## Change the volume for the Sounds audio bus
func _on_sound__volume_changed(value):
	AudioServer.set_bus_volume_db(AudioBus.Sounds, 	linear_to_db(value))

## Sets the new window size multiplying the base resolution with the factor passed
func viewport_change_size(factor : float):
	return # Do not change since changing the size causes problems on the web player
	get_window().size = Constants.BASE_RESOLUTION * factor
