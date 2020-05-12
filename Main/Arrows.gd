extends Node

var Arrow = preload("res://Arrow/Arrow.tscn") 
var Box = preload("res://Box/Box.tscn")

func add_arrow(pos):
	""" Places an arrow at the given position and returns it """
	var a = Arrow.instance()
	a.global_position = pos
	self.add_child(a)
	return a
	
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
	
