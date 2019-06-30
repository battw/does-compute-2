extends Node

export var background_color = Color(100,30,30)

func _ready():
	VisualServer.set_default_clear_color(background_color)
	print(get_viewport().usage)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func add_arrow(pos):
	return $PlayArea.add_arrow(pos)





