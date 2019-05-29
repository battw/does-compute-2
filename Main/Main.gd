extends Node

export var move_speed = 200
export var snap_grid_size = 50
export var background_color = Color(100,30,30)

var arrow = preload("res://Arrow/Arrow.tscn") 
var current_arrow

enum { ADD, INVERT, DELETE }
var mode_names = ["ADD", "INVERT", "DELETE"]
var input_mode = ADD

var move = Vector2.ZERO # Viewport movement direction


var viewport_offset setget , get_viewport_offset
func _ready():
	VisualServer.set_default_clear_color(background_color)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func get_viewport_offset():
	return get_viewport().canvas_transform.get_origin()

func _input(event: InputEvent):	
	
	if event is InputEventKey:
		if event.get_scancode() == KEY_ESCAPE:
			get_tree().quit()
	
	if event.is_action_pressed("save"):
		on_save()
	
	if event.is_action_pressed("load"):
		on_load()
	
	if event.is_action_pressed("change_mode"):
		input_mode = (input_mode + 1) % 3
		if $Cursor:
			$Cursor.set_mode(input_mode)
		print("input mode: " + mode_names[input_mode])
		
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
			
	match input_mode:
		ADD:			
			if event.is_action_pressed("click"):
				var pos = get_viewport().get_mouse_position() - self.viewport_offset
				current_arrow = add_arrow(pos)
				
			elif event.is_action_released("click"):
				current_arrow = null
				
			if current_arrow:
				var mpos = get_viewport().get_mouse_position() - self.viewport_offset
				current_arrow.look_at(mpos)


func _process(delta):	
	get_viewport().canvas_transform = \
	get_viewport().canvas_transform.translated(move * delta * move_speed)


func add_arrow(pos):
	""" Places an arrow at the given position and returns it """
	var a = arrow.instance()
	if snap_grid_size != 0:
		var x = round(pos[0] / snap_grid_size) * int(snap_grid_size)
		var y = round(pos[1] / snap_grid_size) * int(snap_grid_size)
		a.position = Vector2(x, y)
	else:
		a.position = pos
	var arrows = find_node("Arrows", true, false)
	if !arrows:
		print("Could not find Arrows node to add an Arrow to.")
	else:
		arrows.add_child(a)
	return a


func on_arrow_clicked(arrow):
	match input_mode:
		INVERT:
			arrow.invert()
		DELETE:
			arrow.queue_free()


func on_save():
	var saver = find_node("Saver")
	saver.save("sav")

func on_load():
	var saver = find_node("Saver")
	saver.load("sav") 




