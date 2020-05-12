extends Control

export var button_height = 40
var min_button_width = 30

func set_width(width):
	var num_buttons = get_child_count()
	var num_cols = int(width) / int(self.min_button_width)
	var num_rows = int(round(float(num_buttons) / num_cols))

	self.rect_position = Vector2(0, -self.button_height * num_rows)
	var button_width = float(width)/ num_cols
	var pos = Vector2.ZERO
	var kids = get_children()
	for r in range(num_rows - 1):
		for c in range(num_cols):
			var kid = kids.pop_front()
			if kid == null:
				return
			kid.rect_position = pos
			kid.rect_size = Vector2(button_width + 1, self.button_height + 1)
			pos += Vector2(button_width, 0)
		pos = Vector2(0, pos.y + button_height)

	# final row of buttons
	num_cols = len(kids)
	button_width = float(width) / num_cols
	for c in range(num_cols):
		var kid = kids.pop_front()
		if kid == null:
			print("unexpected null button (Buttons.set_size())")
		kid.rect_position = pos
		kid.rect_size = Vector2(button_width + 1, self.button_height + 1)
		pos += Vector2(button_width, 0)


#func set_size(width):
#	self.rect_position = Vector2(0, -self.button_height)
#	self.rect_size = Vector2(width, self.button_height)
#	var button_pos = Vector2.ZERO
#	var button_width = width / get_child_count()
#	for button in get_children():
#		button.rect_size = Vector2(button_width, self.button_height)
#		button.rect_position = button_pos
#		button_pos += Vector2(button_width, 0)
