extends PopupMenu


func _on_about_to_show():
	self.clear()
	for name in $Saver.get_save_names():
		self.add_item(name)



func _on_index_pressed(index):
	# Clear the existing dots
	var dots = get_viewport().find_node("Dots", true, false)
	if dots == null:
		print("Can't find dots (SaveMenu._on_SaveButton_button_down())")
	else:
		if funcref(dots, "clear")  == null:
			print("Dots has no clear() function (SaveMenu._on_SaveButton_button_down())")
		else:
			dots.clear()
			
			
	var filename = self.get_item_text(index)
	$Saver.load(filename)
