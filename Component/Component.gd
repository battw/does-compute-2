extends Node2D

var size = Vector2.ZERO

func _draw():
	draw_rect(Rect2(Vector2.ZERO, self.size), Color(0, 0, 0, .3))

