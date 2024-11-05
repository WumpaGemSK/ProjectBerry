extends Control

## This function receives the _slider_change signal for the MusicControl node
## and emits _music_volume_changed to the Settings autoload
func _on_music_control__slider_changed(value):
	Settings._music_volume_changed.emit(value)

## This function receives the _slider_change signal for the SoundControl node
## and emits _sounds_volume_changed to the Settings autoload
func _on_sound_control__slider_changed(value):
	Settings._sounds_volume_changed.emit(value)
