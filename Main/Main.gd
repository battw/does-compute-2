extends Node

export var background_color = Color(100,30,30)


func _ready():
	VisualServer.set_default_clear_color(background_color)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func zoom(ratio):
	$PlayArea.apply_scale(ratio * Vector2.ONE)


