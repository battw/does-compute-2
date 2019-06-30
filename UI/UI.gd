extends Control

export var move_speed = 200

var delay = Timer.new()

enum { ADD, INVERT, DELETE }
var mode_names = ["ADD", "INVERT", "DELETE"]
var input_mode = ADD

var main
var current_arrow

var move = Vector2.ZERO # Viewport movement direction

func _process(delta):
	get_viewport().canvas_transform = \
	get_viewport().canvas_transform.translated(self.move  *  self.move_speed * delta)
	self.rect_position = -get_viewport().canvas_transform.get_origin()

func _enter_tree():
	self.main = self.find_parent("Main")

func _exit_tree():
	self.main = null
	

	
func _on_gui_input(event):
	if event.is_action_pressed("change_mode"):
		input_mode = (input_mode + 1) % 3
		if $Cursor:
			$Cursor.set_mode(input_mode)
		print("input mode: " + mode_names[input_mode])
		
	match input_mode:
		ADD:			
			if event.is_action_pressed("click"):
				var pos = get_viewport().get_mouse_position() - get_viewport().canvas_transform.get_origin()
				current_arrow = self.main.add_arrow(pos)
				
			elif event.is_action_released("click"):
				current_arrow = null
				
			if current_arrow:
				var mpos = get_viewport().get_mouse_position() - get_viewport().canvas_transform.get_origin()
				current_arrow.look_at(mpos)
		INVERT:
			if event.is_action_pressed("click"):
				for arrow in $Cursor.get_arrows():
					arrow.invert()
		DELETE:
			if event.is_action_pressed("click"):
				for arrow in $Cursor.get_arrows():
					arrow.delete()
					
func _unhandled_input(event):
	if event.is_action_type():
		if event.is_action_pressed("up"):
			move += Vector2.DOWN
		if event.is_action_pressed("down"):
			move += Vector2.UP
		if event.is_action_pressed("left"):
			move += Vector2.RIGHT
		if event.is_action_pressed("right"):
			move += Vector2.LEFT
		if event.is_action_released("up"):
			move -= Vector2.DOWN
		if event.is_action_released("down"):
			move -= Vector2.UP
		if event.is_action_released("left"):
			move -= Vector2.RIGHT
		if event.is_action_released("right"):
			move -= Vector2.LEFT
