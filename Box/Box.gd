extends Node2D

export var size = Vector2.ZERO setget _set_size
var button_visibility = false setget _set_button_visibility
var is_moving_copy = false
const Arrow = preload("res://Arrow/Arrow.tscn")
var mouse_over_buttons = false
var mouse_over_box = false


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
	if $Area2D == null:
		print("$Area2D == null (Box._set_size())")
	else:
		$Area2D.position = size / 2
		if $Area2D/CollisionShape2D == null:
			print("$Area2D/CollisionShape2D == null (Box._set_size())")
		else:
			if $Area2D/CollisionShape2D.shape == null:
				$Area2D/CollisionShape2D.shape = RectangleShape2D.new()
			$Area2D/CollisionShape2D.shape.extents = size / 2
			
	
	if $Contents == null:
		print("$Contents == null (Box._set_size())")
	else:
		$Contents.position = size / 2
		
	if $Buttons == null:
		print("$Buttons == null (Box._set_size())")
	else:
		$Buttons.set_size(size.x)
	
func copy():
	var dup = duplicate()
	dup.find_node("Area2D").get_child(0).shape = RectangleShape2D.new() # otherwise the duplicates reference the same shape
	dup.transform.origin = Vector2.ONE
	dup.size = Vector2(self.size.x, self.size.y)
	
	return dup
	
func kill():
	# delete the component and all of the arrows it contains
	get_parent().get_child(get_index())
	queue_free()
	
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
	
	
	
#	for c in cop.find_node("Contents", true, false).get_children():
#		print(c.find_node("CollisionShape2D", true, false).shape)


func _set_button_visibility(value):
	button_visibility = value
	$Buttons.visible = value


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
	
func save():
	var data = {}
	data["type"] = "Box"
	data["size"] = self.size
	data["position"] = self.position
	data["contents"] = {}
	for item in $Contents.get_children():
		if item.name.match("*Arrow*"):
			data["contents"][item.name] = item.save()
	return data

func load(data):
	self.size = data["size"]
	self.position = data["position"]
	for name in data["contents"]:
		if name.match("*Arrow*"):
			var a = Arrow.instance()
			a.load(data["contents"][name])
			$Contents.add_child(a)


func _on_Buttons_mouse_entered():
	self.mouse_over_buttons = true
	_update_visibility()

func _on_Buttons_mouse_exited():
	self.mouse_over_buttons = false
	_update_visibility()
	
func _on_Area2D_area_entered(area):
	self.mouse_over_box = true
	_update_visibility()

func _on_Area2D_area_exited(area):
	self.mouse_over_box = false
	_update_visibility()
	
func _update_visibility():
	self.button_visibility = ! self.is_moving_copy and (self.mouse_over_box or self.mouse_over_buttons)

func mirror():
	for arrow in $Contents.get_children():
		arrow.transform = arrow.transform.rotated($Contents.rotation)
		arrow.position.x *= -1
		var pos = arrow.position
		arrow.position = Vector2.ZERO
		var rot = arrow.rotation
		arrow.rotation -= PI / 2
		arrow.rotation *= -1
		arrow.rotation += PI / 2
		arrow.position = pos
	$Contents.rotation = 0
