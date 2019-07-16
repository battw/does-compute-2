extends Control

export var button_height = 20

func set_size(size):
	var button_pos = Vector2.ZERO
	var button_xsize = size / get_child_count()
	for button in get_children():
		button.rect_size = Vector2(button_xsize, self.button_height)
		button.rect_position = button_pos
		button_pos += Vector2(button_xsize, 0)