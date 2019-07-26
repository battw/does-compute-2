extends Node2D

func clear():
	for c in get_children():
		if c.name.match("*Dot*"):
			c.queue_free()