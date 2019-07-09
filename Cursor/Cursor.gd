extends Node2D

enum { ADD, INVERT, DELETE, SELECT }
	
func _process(delta):
	self.position = get_parent().get_local_mouse_position()
	self.scale = Vector2.ONE / get_viewport_transform().get_scale()
	
func set_mode(mode):	
	$Add.visible = false
	$Delete.visible = false
	$Invert.visible = false
	$Select.visible = false
	match mode:
		ADD:
			$Add.visible = true
		INVERT:
			$Invert.visible = true
		DELETE:
			$Delete.visible = true
		SELECT:
			$Select.visible = true

func get_arrows():
	var arrows = []
	for area in $Area2D.get_overlapping_areas():
		var arrow = area.find_parent("*Arrow*")
		if arrow:
			arrows.append(arrow)
	return arrows
