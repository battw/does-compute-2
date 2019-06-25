extends GridContainer

func display():
	for c in self.get_children():
		c.visible = true