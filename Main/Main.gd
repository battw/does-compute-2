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
	var scaled_grid = grid_size  * $PlayArea.global_scale
	var x = round(position[0] / scaled_grid[0]) * scaled_grid[0]
	var y = round(position[1] / scaled_grid[1]) * scaled_grid[1]
	var maxX = $PlayArea.size.x
	var maxY = $PlayArea.size.y
	if x < 0:
		x = 0
	if x > maxX:
		x = maxX
	if y < 0:
		y = 0
	if y > maxY:
		y = maxY
	return Vector2(x, y)
	
