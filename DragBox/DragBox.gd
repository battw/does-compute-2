extends Node2D


export var color = Color(1, 1, 1, .2)

var main

var click_position
var top_left
var size


func _enter_tree():
	self.main = find_parent("Main")

func _draw():
	if self.top_left == null or self.size == null:
		return
	
	var rect = Rect2(self.top_left - self.global_position, self.size - self.global_position)
	draw_rect(rect, self.color)

	
func drag_on():
	self.click_position = main.snap_to_grid(get_global_mouse_position())
	

func drag():
	var drag_position = main.snap_to_grid(get_global_mouse_position())
	update_size(drag_position)
	update()

func update_size(drag_position):
	var minX = min(click_position.x, drag_position.x)
	var minY = min(click_position.y, drag_position.y)
	var maxX = max(click_position.x, drag_position.x)
	var maxY = max(click_position.y, drag_position.y)
	self.top_left = Vector2(minX, minY)
	self.size = Vector2(maxX, maxY) - top_left
	$Area2D.global_position = top_left + size / 2
	$Area2D/CollisionShape2D.shape.extents = size / 2
	

func drag_off():	
	var arrows = $Area2D.get_overlapping_areas()
	
	get_parent().remove_child(self)
	queue_free()
	
	return {"position": top_left, "size": size, "arrows": arrows}
	
