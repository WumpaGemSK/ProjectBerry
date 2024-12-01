extends Resource
class_name SoundEffect

enum SoundType {
	# Enemy
	ENEMY_DRAW_WEAPON,
	ENEMY_GETS_HURT,
	ENEMY_RUN,
	ENEMY_SHOOT,
	ENEMY_SLEEPING,
	# Enviroment
	EXPLOSION,
	FAX_MACHINE,
	STEP_ON_MINE,
	# Interactables
	CRICKET_BAT_HIT,
	OPEN_DOOR,
	PICKUP_ITEM,
	TURN_ON_MACHINE,
	# Player
	PLAYER_DEATH,
	PLAYER_HURT,
	PLAYER_PUSH,
	PLAYER_SNEAKING,
	PLAYER_WALKING,
	# UI
	UI_CANCEL,
	UI_CONFIRM,
	UI_CORRECT_CODE,
	UI_INCORECT_CODE,
	UI_LOGO_LAUGH,
	UI_NAVIGATE,
	UI_NUCLEAR_EXPLOSION,
	UI_OPEN_MENU,
	UI_TERMINAL_INPUT
}

@export_range(0, 10) var limit: int = 5
@export var type: SoundType
@export var sound_effect: AudioStream
@export_range(-40, 20) var volume = 0
@export_range(0.0, 4.0,.01) var pitch_scale = 1.0
@export_range(0.0, 1.0,.01) var pitch_randomness = 0.0
@export var interval: float = 0

var timer: Timer
var on_cooldown: bool = false
var audio_count = 0

func change_audio_count(amount: int):
	audio_count = max(0, audio_count + amount)
	
func has_open_limit() -> bool:
	return audio_count < limit and timer.is_stopped()
	
func on_audio_finished():
	if interval != 0:
		timer.start(interval)
	change_audio_count(-1)

func set_timer(t: Timer):
	timer = t
	timer.one_shot = true
	timer.stop()
