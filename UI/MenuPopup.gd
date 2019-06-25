extends PopupMenu

func _ready():
	self.add_item("SAVE")
	self.add_item("LOAD")
	self.add_item("EXIT")


func _on_index_pressed(index):
	var action = get_item_text(index)
	if action == "SAVE":
		$SaveMenu.popup_centered()
	elif action == "LOAD":
		$LoadMenu.popup_centered()
