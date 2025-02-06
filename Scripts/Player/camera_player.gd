extends Camera2D

var rand : RandomNumberGenerator = RandomNumberGenerator.new()
var noise : FastNoiseLite = FastNoiseLite.new()

@export var noise_shake_strength : float = 10.0
@export var duration : float = 1

func _ready():
	rand.randomize()
	noise.seed = rand.randi()
	noise.frequency = 2

func shake():
	var tween = create_tween()
	tween.tween_method(get_noise_offset, noise_shake_strength, 0, duration)

func get_noise_offset(noise_strength: float):
	offset = Vector2(
		noise.get_noise_1d(rand.randf())*noise_strength,
		noise.get_noise_1d(rand.randf())*noise_strength
	)
