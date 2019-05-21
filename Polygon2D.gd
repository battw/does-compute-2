extends Polygon2D

export var other_color: Color

func invert_color():
	var tmp_color = color
	color = other_color
	other_color = tmp_color