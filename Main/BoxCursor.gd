extends Node2D

var main

func _enter_tree():
	self.main = find_parent("Main")

func _process(delta):
	if self.main == null:
		print("variable main not set in BoxCursor._process()")
		self.position = get_parent().get_local_mouse_position()
	else:
		var global_mouse_snap = self.main.snap_to_grid(get_parent().get_global_mouse_position())
		self.position = get_parent().to_local(global_mouse_snap)


func kill_box():
	var box = find_node("*Box*", true, false)
	if box != null:
		box.kill()