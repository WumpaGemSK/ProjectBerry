extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var bag_of_coins: PickableItem = $BagofCoins

func _ready() -> void:
	
	sprite.frame = 0

func gets_destroyed():
	
	print("Destroyed")
	sprite.frame = 1
	bag_of_coins.position = Vector2(0, 20)
