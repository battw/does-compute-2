extends Node

var arrow = preload("res://Arrow/Arrow.tscn") 
var current_arrow

enum { ADD, INVERT, DELETE }
var mode_names = ["ADD", "INVERT", "DELETE"]
var input_mode = ADD

#func _ready():
#	VisualServer.set_default_clear_color(Color(0, 0, 0))


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
		print("input mode: " + mode_names[input_mode])
		
	match input_mode:
		ADD:			
			if event.is_action_pressed("click"):
				var pos = get_viewport().get_mouse_position()
				current_arrow = add_arrow(pos)
				
			elif event.is_action_released("click"):
				current_arrow = null
				
			elif event is InputEventMouseMotion and current_arrow:
				var mpos = get_viewport().get_mouse_position()
				current_arrow.look_at(mpos)


func add_arrow(pos):
	""" Places an arrow at the given position and returns it """
	var a = arrow.instance()
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



