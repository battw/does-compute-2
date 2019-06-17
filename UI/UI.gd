extends Control

var has_mouse = false
var delay = Timer.new()

func _ready():
	pass
		
func _process(delta):
	self.rect_position = -get_viewport().canvas_transform.get_origin()

func _on_mouse_entered():
	has_mouse = true

func _on_mouse_exited():
	# The delay means control isn't handed immediately back to the input handling in main.
	# It prevents accidental input.
	delay.connect("timeout", self, "_return_mouse")
	delay.start(2.0)
	self.add_child(delay)
	
func _return_mouse():
	has_mouse = false
