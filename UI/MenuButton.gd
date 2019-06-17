extends Button

func _ready():
	self.visible = false

func _gui_input(event):
	if event is InputEventMouseButton:
		$SaveMenu.popup_centered()