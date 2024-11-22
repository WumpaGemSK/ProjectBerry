extends Control

@onready var prev = %Prev
@onready var next = %Next
@onready var list = %List

@export var element_scn: PackedScene

@export var elements_per_page: int = 5
var current_page: int = 0

var scores : Array[GameScore]
# Called when the node enters the scene tree for the first time.
func _ready():
	scores = Leaderboard.scores.scores
	render()

func render():
	var elements_left = scores.size() - current_page*elements_per_page
	next.visible = elements_left > elements_per_page
	prev.visible = current_page > 0
	render_list()
	
func render_list():
	for child in list.get_children():
		list.remove_child(child)
	var starting_index = current_page*elements_per_page
	var end_index = min(starting_index+elements_per_page, scores.size())
	for i in range(starting_index, end_index):
		var entry = element_scn.instantiate()
		list.add_child(entry)
		var score = scores[i]
		entry.set_data("Test", "Data %d" % i)

func _on_prev_pressed():
	current_page -= 1
	render()

func _on_next_pressed():
	current_page += 1
	render()
