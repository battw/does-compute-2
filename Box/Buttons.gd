extends Control

export var button_height = 40

func set_size(xsize):
	self.rect_position = Vector2(0, -self.button_height)
	self.rect_size = Vector2(xsize, self.button_height)
	var button_pos = Vector2.ZERO
	var button_xsize = xsize / get_child_count()
	for button in get_children():
		button.rect_size = Vector2(button_xsize, self.button_height)
		button.rect_position = button_pos
		button_pos += Vector2(button_xsize, 0)