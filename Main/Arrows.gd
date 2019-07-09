extends Node

var Arrow = preload("res://Arrow/Arrow.tscn") 
var Component = preload("res://Component/Component.tscn")

func add_arrow(pos):
	""" Places an arrow at the given position and returns it """
	var a = Arrow.instance()
	a.global_position = pos
	self.add_child(a)
	return a
	
func create_component(position, size, arrows):
	var c = Component.instance()
	c.position = position
	c.size = size
	for a in arrows:
		if a in get_children():
			remove_child(a)
			a.transform = c.transform.affine_inverse() * a.transform
			c.add_child(a)
	self.add_child(c)
