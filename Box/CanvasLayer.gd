extends CanvasLayer

func _enter_tree():
	self.transform = get_parent().transform

#func _process(delta):
#	self.transform = get_parent().transform
