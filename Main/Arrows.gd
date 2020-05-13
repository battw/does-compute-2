extends Node

var Arrow = preload("res://Arrow/Arrow.tscn")
var Box = preload("res://Box/Box.tscn")

var selected_arrow

func add_arrow(pos):
	""" Places an arrow at the given position and returns it """
	self.selected_arrow  = Arrow.instance()
	self.selected_arrow.global_position = pos
	self.add_child(self.selected_arrow)

func point_arrow(pos):
	if (selected_arrow != null):
		selected_arrow.look_at(pos)

func create_box(position, size, arrows):
	var b = Box.instance()
	b.position = position
	b.size = size
	add_child(b)
	for a in arrows:
		if a in get_children():
			a.transform = a.global_transform
			remove_child(a)
			b.add_arrow(a)

