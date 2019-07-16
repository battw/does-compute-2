extends Node2D

export var size = Vector2.ZERO setget _set_size
var button_visibility = false setget _set_button_visibility
var is_moving_copy = false


func _enter_tree():
	var buttons = find_node("Buttons").get_children()
	
	$Buttons.visible = false


func _draw():
	draw_rect(Rect2(Vector2.ZERO, self.size), Color(0, 0, 0, .3))

func add_arrow(arrow):
	$Contents.add_child(arrow)
	arrow.transform = $Contents.global_transform.affine_inverse() * arrow.transform

func _on_Copy_pressed():
	# copy the box and attach the copy to the cursor
	var cursor = get_viewport().find_node("BoxCursor", true, false)
	if cursor == null:
		print("can't find BoxCursor (Box._on_Copy_pressed)")
		return
		
	var ui = get_viewport().find_node("UIControl", true, false)
	if ui == null:
		print("can't find UIControl (Box._on_Copy_pressed)")
		return
	
	if cursor.get_child_count() > 0:
		print("can't attach copy of box to BoxCursor as it already has a child (Box._on_Copy_pressed)")
		return
	
	var cop = copy()
	cop.button_visibility = false
	cop.is_moving_copy = true
	cursor.add_child(cop)
	
	ui.set_move_mode(true)

func _set_size(a_size):
	size = a_size
	$Area2D/CollisionShape2D.shape.extents = size / 2
	$Area2D.position = size / 2
	$Contents.position = size / 2
	$Buttons.set_size(size.x)
	
func copy():
	var dup = duplicate()
	dup.transform.origin = Vector2.ONE
	#dup.size = Vector2(self.size.x, self.size.y)
	return dup
	
func kill():
	# delete the component and all of the arrows it contains
	get_parent().get_child(self.get_index())
	self.queue_free()
	
func paste():
	var arrows = get_viewport().find_node("Arrows", true, false)
	if arrows == null:
		print("can't find Arrows (Box.paste())")
		return
	
	var cursor = find_parent("BoxCursor")
	if cursor == null:
		print("can't find BoxCursor (Box.paste())")
	
	var cop = copy()
	arrows.add_child(cop)
	cop.position = arrows.to_local(cursor.get_parent().to_global(cursor.position))


func _set_button_visibility(value):
	button_visibility = value
	$Buttons.visible = value


func _on_Area2D_area_entered(area):
	if ! self.is_moving_copy:
		self.button_visibility = true


func _on_Area2D_area_exited(area):
	self.button_visibility = false


func rot():
	$Contents.rotate(PI / 2)
	self.size = Vector2(self.size.y, self.size.x)
	update()


func remove():
	var arrows = get_viewport().find_node("Arrows", true, false)
	if arrows == null:
		print("can't find Arrows (Box.remove())")
	for c in $Contents.get_children():
		if c.name.match("*Arrow*"):
			c.transform = arrows.global_transform.affine_inverse() * c.global_transform
			$Contents.remove_child(c)	
			arrows.add_child(c)
	kill()
