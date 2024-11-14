extends Control

@export var health_unit_scene : PackedScene
@export var player : Player
@onready var health_units = %HealthUnits

func _ready():
	player.health_changed.connect(on_health_changed)
	populate_health(player.health, player.max_health)

func on_health_changed(new_health):
	for child in health_units.get_children():
		health_units.remove_child(child)
	populate_health(new_health, player.max_health)

func populate_health(health: int, max_health: int):
	for i in range(player.health):
		var health_unit = health_unit_scene.instantiate()
		health_units.add_child(health_unit)
		health_unit.set_full()
	
	while(health_units.get_child_count() < max_health):
		var health_unit = health_unit_scene.instantiate()
		health_units.add_child(health_unit)
		health_unit.set_empty()
