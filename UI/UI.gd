extends Control

export var move_speed = 200
export var zoom_factor = 0.2

var delay = Timer.new()

enum { ADD, INVERT, DELETE, SELECT }
var mode_names = ["ADD", "INVERT", "DELETE", "SELECT"]
var input_mode = ADD
var main
var cursor
var current_arrow
var DragBox = preload("res://DragBox/DragBox.tscn")
var dragbox

var move = Vector2.ZERO # Viewport movement direction

func _process(delta):
	get_viewport().canvas_transform = \
		get_viewport().canvas_transform.translated(self.move  *  self.move_speed * delta)


func _enter_tree():
	self.main = self.find_parent("Main")
	self.rect_size = get_viewport_rect().size
	self.cursor = main.find_node("Cursor")


func _exit_tree():
	self.main = null

func _get_model_mouse_position():
	return get_viewport().canvas_transform.affine_inverse() * get_viewport().get_mouse_position()

func _on_gui_input(event):

	if event.is_action_pressed("change_mode"):
		input_mode = (input_mode + 1) % 4
		if cursor:
			cursor.set_mode(input_mode)
		# print("input mode: " + mode_names[input_mode])

	if event.is_action("zoom_out"):
		get_viewport().canvas_transform = \
			get_viewport().canvas_transform.scaled(Vector2.ONE - Vector2.ONE * self.zoom_factor)
			
	if event.is_action("zoom_in"):
		get_viewport().canvas_transform = \
			get_viewport().canvas_transform.scaled(Vector2.ONE + Vector2.ONE * self.zoom_factor)
			
	match input_mode:
		ADD:			
			if event.is_action_pressed("click"):
				var pos = _get_model_mouse_position()
				current_arrow = self.main.add_arrow(pos)
				
			elif event.is_action_released("click"):
				current_arrow = null
				
			if current_arrow:
				var mpos = _get_model_mouse_position()
				current_arrow.look_at(mpos)
		INVERT:
			if event.is_action_pressed("click"):
				for arrow in cursor.get_arrows():
					arrow.invert()
		DELETE:
			if event.is_action_pressed("click"):
				for arrow in cursor.get_arrows():
					arrow.delete()
		SELECT:
			if event.is_action_pressed("click"):
				self.dragbox = DragBox.instance()
				main.add_child(self.dragbox)
				self.dragbox.drag_on()
				
			elif event.is_action_released("click"):
				var res = self.dragbox.drag_off()
				self.dragbox = null
				var arrows = main.find_node("Arrows")
				if arrows:
					arrows.create_component(res["position"], res["size"], res["arrows"])
				
			elif self.dragbox:
				self.dragbox.drag()



func _unhandled_input(event):
	if event.is_action_type():
		if event.is_action_pressed("up"):
			move += Vector2.DOWN
		elif event.is_action_pressed("down"):
			move += Vector2.UP
		elif event.is_action_pressed("left"):
			move += Vector2.RIGHT
		elif event.is_action_pressed("right"):
			move += Vector2.LEFT
		elif event.is_action_released("up"):
			move -= Vector2.DOWN
		elif event.is_action_released("down"):
			move -= Vector2.UP
		elif event.is_action_released("left"):
			move -= Vector2.RIGHT
		elif event.is_action_released("right"):
			move -= Vector2.LEFT
