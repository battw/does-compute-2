extends Node

var arrow = preload("res://Arrow/Arrow.tscn") 

func add_arrow(pos):
	# print("add arrow")
	""" Places an arrow at the given position and returns it """
	var a = arrow.instance()
	a.global_position = pos
	self.add_child(a)
	return a
	