extends Control

@onready var music_control = $VBoxContainer/MusicControl
@onready var sound_control = $VBoxContainer/SoundControl

## This function receives the _slider_change signal for the MusicControl node
## and emits _music_volume_changed to the Settings autoload
func _on_music_control__slider_changed(value):
	Settings._music_volume_changed.emit(value)

## This function receives the _slider_change signal for the SoundControl node
## and emits _sounds_volume_changed to the Settings autoload
func _on_sound_control__slider_changed(value):
	Settings._sounds_volume_changed.emit(value)

## Set the volume by reading the audio bus volumes
func _ready():
	var music_volume = db_to_linear(AudioServer.get_bus_volume_db(Settings.AudioBus.Music))
	var sound_volume = db_to_linear(AudioServer.get_bus_volume_db(Settings.AudioBus.Sounds))
	music_control.set_value(music_volume)
	sound_control.set_value(sound_volume)
