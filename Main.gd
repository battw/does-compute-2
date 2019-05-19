extends Node

onready var arrow = preload("res://Arrow.tscn")
var current_arrow

func _ready():
	VisualServer.set_default_clear_color(Color(0, 0, 0))


func _input(event: InputEvent):
	if event is InputEventKey:
		if event.get_scancode() == KEY_ESCAPE:
			get_tree().quit()
			
	if event.is_action_pressed("click"):
		var pos = get_viewport().get_mouse_position()
		current_arrow = add_arrow(pos)
	elif event.is_action_released("click"):
		current_arrow = null
	elif event is InputEventMouseMotion and current_arrow:
		var mpos = get_viewport().get_mouse_position()
		current_arrow.look_at(mpos)


func add_arrow(pos):
	""" Places an arrow at the given position and returns it """
	var a = arrow.instance()
	a.position = pos
	add_child(a)
	return a