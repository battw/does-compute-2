extends Node2D

func clear():
	for c in get_children():
		if c.name.match("*Dot*"):
			DotFactory.recycle(c)