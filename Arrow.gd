extends Node2D

onready var dot = preload("res://Dot.tscn")
var inv = false
var hit = false # the Arrow has been hit by a Dot since the last tick
var main
signal arrow_clicked(arrow)


func _ready():
	add_to_group("Arrows")
	add_to_group("Tickers")
	
	
func _enter_tree():
	main = find_parent("Main")
	if main != null:
		connect("arrow_clicked", main, "on_arrow_clicked")
	
	
func hit(area2d):
	var d = area2d.find_parent("*Dot*")
	if d != null and d.arrow != self:
		hit = true
		d.queue_free()


func tick():
	if (hit and !inv) or (inv and !hit):
		emit()
	hit = false


func emit():
	var d = dot.instance()
	d.direction = Vector2.RIGHT.rotated(transform.get_rotation())
	d.position = position
	d.arrow = self
	get_tree().get_root().add_child(d) 
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		emit_signal("arrow_clicked", self)

func invert():
	inv = !inv