extends Node2D


export var color = Color(1, 1, 1, .2)
var snap = true
var drag_on_position
var drag_position
var main

func _enter_tree():
	self.main = find_parent("Main")

func _draw():
	if !drag_on_position or !drag_position:
		return
	
	var rect = Rect2(self.drag_on_position, self.drag_position - self.drag_on_position)
	draw_rect(rect, self.color)

	
func drag_on():
	self.drag_on_position = get_global_mouse_position()
	if snap:
		self.drag_on_position = main.snap_to_grid(self.drag_on_position)
	

func drag():
	self.drag_position = get_global_mouse_position()
	if snap:
		self.drag_position = main.snap_to_grid(self.drag_position)
	update()

func drag_off():
	get_parent().remove_child(self)
	queue_free()
	
