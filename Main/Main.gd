extends Node

export var background_color = Color(100,30,30)
export var grid_size = 50

func _ready():
	VisualServer.set_default_clear_color(background_color)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func add_arrow(pos):
	return $PlayArea.add_arrow(snap_to_grid(pos))


func zoom(ratio):
	$PlayArea.apply_scale(ratio * Vector2.ONE)


func snap_to_grid(position):
	var x = round(position[0] / grid_size) * int(grid_size)
	var y = round(position[1] / grid_size) * int(grid_size)
	return Vector2(x, y)
	
