extends Control

@onready var item_name = %ItemName
@onready var item_decription = %ItemDecription

func show_detail(item : Item):
	item_name.text = item.item_name
	item_decription.text = item.description

func clear():
	item_decription.text = ""
	item_name.text = ""
