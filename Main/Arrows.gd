extends Node

var Arrow = preload("res://Arrow/Arrow.tscn") 
var Box = preload("res://Box/Box.tscn")

func add_arrow(pos):
	""" Places an arrow at the given position and returns it """
	var a = Arrow.instance()
	a.global_position = pos
	self.add_child(a)
	return a
	
func create_component(position, size, arrows):
	var b = Box.instance()
	b.position = position
	b.size = size
	for a in arrows:
		if a in get_children():
			remove_child(a)
			a.transform = b.transform.affine_inverse() * a.transform
			b.add_child(a)
	self.add_child(b)
