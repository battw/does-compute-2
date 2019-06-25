extends Node

var arrow = preload("res://Arrow/Arrow.tscn") 

func add_arrow(pos, snap_grid_size):
	print("add arrow")
	""" Places an arrow at the given position and returns it """
	var a = arrow.instance()
	if snap_grid_size != 0:
		var x = round(pos[0] / snap_grid_size) * int(snap_grid_size)
		var y = round(pos[1] / snap_grid_size) * int(snap_grid_size)
		a.position = Vector2(x, y)
	else:
		a.position = pos
	
	self.add_child(a)
	return a
	