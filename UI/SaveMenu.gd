extends PopupMenu


func _ready():
	self.hide_on_item_selection = false

func _on_about_to_show():
	self.clear()
	for i in range(5):
		add_item("save" + str(i))


func _on_index_pressed(index):
	$LineEdit.text = get_item_text(index)


func _on_SaveButton_button_down():
	if $LineEdit.text != "":
		$Saver.save($LineEdit.text)
	

func _on_SaveButton_button_up():
	self.hide()

