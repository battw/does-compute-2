extends PopupMenu


func _on_about_to_show():
	self.clear()
	for name in $Saver.get_save_names():
		self.add_item(name)



func _on_index_pressed(index):
	var filename = self.get_item_text(index)
	$Saver.load(filename)
