extends Control

export var move_speed = 100
export var zoom_factor = 0.2

signal arrow_add_signal(pos)
signal arrow_point_signal(pos)

enum { ADD, INVERT, DELETE, SELECT, MOVE }
var mode_names = ["ADD", "INVERT", "DELETE", "SELECT", "MOVE"]
var input_mode = ADD
var main
var cursor
var has_drag_arrow = false
var DragBox = preload("res://DragBox/DragBox.tscn")
var dragbox
var keys_disabled = false

var move = Vector2.ZERO # Viewport movement direction

func _ready():
	self.main = self.find_parent("Main")
	self.rect_size = get_viewport_rect().size
	self.cursor = main.find_node("Cursor")
	connect("arrow_add_signal", get_tree().get_root().find_node("Arrows", true, false), "add_arrow")
	connect("arrow_point_signal", get_tree().get_root().find_node("Arrows", true, false), "point_arrow")

func _process(delta):
	var game_scale = get_viewport().canvas_transform.get_scale().x
	get_viewport().canvas_transform = \
		get_viewport().canvas_transform.translated(self.move  *  self.move_speed * delta * (3 / game_scale))




func _exit_tree():
	self.main = null

func _get_model_mouse_position():
	return get_viewport().canvas_transform.affine_inverse() * get_viewport().get_mouse_position()

func _on_gui_input(event):
	handle_zoom(event)
	handle_mode_change(event)
	match input_mode:
		ADD:
			handle_add(event)
		INVERT:
			handle_invert(event)
		DELETE:
			handle_delete(event)
		SELECT:
			handle_select(event)
		MOVE:
			handle_move(event)

func set_move_mode(event):
	self.input_mode = MOVE
	self.cursor.set_mode(MOVE)


func handle_mode_change(event):
	if event.is_action_pressed("change_mode"):
		var box_curs = get_viewport().find_node("BoxCursor", true, false)
		if box_curs != null:
			box_curs.kill_box()

		if self.input_mode == MOVE:
			self.input_mode = 0
		else:
			self.input_mode = (self.input_mode + 1) % 4
		if cursor:
			cursor.set_mode(self.input_mode)


func handle_zoom(event):
	if !event.is_action("zoom_out") and !event.is_action("zoom_in"):
		return

	var mouse_position = get_global_mouse_position()
	get_viewport().canvas_transform.origin -= mouse_position

	if event.is_action("zoom_out"):
		get_viewport().canvas_transform = \
			get_viewport().canvas_transform.scaled(Vector2.ONE - Vector2.ONE * self.zoom_factor)

	if event.is_action("zoom_in"):
		get_viewport().canvas_transform = \
			get_viewport().canvas_transform.scaled(Vector2.ONE + Vector2.ONE * self.zoom_factor)

	get_viewport().canvas_transform.origin += mouse_position


func handle_add(event):
	var pos = _get_model_mouse_position()
	if event.is_action_pressed("click"):
		emit_signal("arrow_add_signal", pos)
		self.has_drag_arrow = true
	elif event.is_action_released("click"):
		self.has_drag_arrow = false
	elif self.has_drag_arrow:
		emit_signal("arrow_point_signal", pos)

#	if current_arrow != null:
#		var mpos = _get_model_mouse_position()
#		current_arrow.look_at(mpos)

func handle_invert(event):
	if event.is_action_pressed("click"):
		for arrow in cursor.get_arrows():
			arrow.invert()

func handle_delete(event):
	if event.is_action_pressed("click"):
		for arrow in cursor.get_arrows():
			arrow.delete()

func handle_select(event):
	if event.is_action_pressed("click"):
		self.dragbox = DragBox.instance()
		main.add_child(self.dragbox)
		self.dragbox.drag_on()

	elif event.is_action_released("click"):
		var res = self.dragbox.drag_off()
		self.dragbox = null
		if res == null:
			return
		var arrows = main.find_node("Arrows")
		if arrows != null and res["size"]:
			arrows.create_box(res["position"], res["size"], res["arrows"])

	elif self.dragbox:
		self.dragbox.drag()

func handle_move(event):
	var box_cursor = self.get_viewport().find_node("BoxCursor", true, false)
	if box_cursor == null:
		print("can't find box cursor (UI.handle_move()")
		return

	var box = box_cursor.find_node("*Box*", true, false)
	if box == null:
		print("can't find box (UI.handle_move())")
		return

	if event.is_action_pressed("cancel_copy"):
		box_cursor.remove_child(box)
		self.copying_box = false

	if event.is_action_pressed("click"):
		box.paste()

func _unhandled_input(event):
	if !self.keys_disabled and event.is_action_type():
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

func _disable_keys():
	self.keys_disabled = true

func _allow_keys():
	self.keys_disabled = false
