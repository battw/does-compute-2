extends Node2D

var play_area

func _enter_tree():
	self.play_area = find_parent("PlayArea")

func _process(delta):
	if self.play_area == null:
		print("variable self.play_area not set in BoxCursor._process()")
		self.position = get_parent().get_local_mouse_position()
	else:
		var global_mouse_snap = self.play_area.snap_to_grid(get_parent().get_global_mouse_position())
		self.position = get_parent().to_local(global_mouse_snap)


func kill_box():
	var box = find_node("*Box*", true, false)
	if box != null:
		box.kill()
