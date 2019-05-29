extends Node2D

enum { ADD, INVERT, DELETE }
	
func _process(delta):
	self.position = get_viewport().get_mouse_position() - get_viewport().canvas_transform.get_origin()

func set_mode(mode):
	if !$Add or !$Invert or !$Delete:
		print("Cursor missing children")
		return
		
	$Add.visible = false
	$Delete.visible = false
	$Invert.visible = false
	match mode:
		ADD:
			$Add.visible = true
		INVERT:
			$Invert.visible = true
		DELETE:
			$Delete.visible = true
			
