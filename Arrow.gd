extends Node2D

onready var dot = preload("res://Dot.tscn")
var inv = true
var has_input = false


func _ready():
	add_to_group("Arrows")
	add_to_group("Tickers")

func tick():
	if (has_input and !inv) or (inv and !has_input):
		emit()

func emit():
	var d = dot.instance()
	d.direction = Vector2.RIGHT.rotated(transform.get_rotation())
	d.position = self.position
	get_tree().get_root().add_child(d)