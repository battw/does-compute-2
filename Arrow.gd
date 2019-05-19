extends Node2D

onready var dot = preload("res://Dot.tscn")
var inv = true
var hit = false # the Arrow has been hit by a Dot since the last tick


func _ready():
	add_to_group("Arrows")
	add_to_group("Tickers")
	
func hit(area2d):
	var d = area2d.find_parent("*Dot*")
	if d != null and d.arrow != self:
		hit = true

func tick():
	if (hit and !inv) or (inv and !hit):
		emit()
	hit = false

func emit():
	var d = dot.instance()
	d.direction = Vector2.RIGHT.rotated(transform.get_rotation())
	d.position = self.position
	d.arrow = self
	get_tree().get_root().add_child(d) 