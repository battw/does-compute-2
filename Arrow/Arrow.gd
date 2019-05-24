extends Node2D

onready var dot = preload("res://Dot/Dot.tscn")
var inv = false setget set_inv, get_inv
var hit = false # the Arrow has been hit by a Dot since the last tick
var other_color = Color(30,30,30) # swaps between this and the main color when arrows are inverted.
signal arrow_clicked(arrow)

func get_inv():
	return inv

func set_inv(abool):
	if abool != inv:
		inv = abool
		var poly = find_node("Polygon2D")
		poly.invert_color()

func _ready():
	add_to_group("Arrows")
	add_to_group("Tickers")
	add_to_group("Savable")
	
	
func _enter_tree():
	var main = find_parent("Main")
	if main != null:
		connect("arrow_clicked", main, "on_arrow_clicked")
	
	
func hit(area2d):
	""" Called by signal from the arrows Area2d """
	var d = area2d.find_parent("*Dot*")
	if d != null and !d.from_arrows.has(self):
		var neighbours = get_contiguous_neighbours()
		for n in neighbours:
			n.hit = true
		d.queue_free()

func get_contiguous_neighbours(visited=[self]):
	""" returns an array of all arrows which form a contiguous area which includes this arrow.
	An argument shouldn't be given, it is used for recursive calls by this function. """
	var area = find_node("*Area2D*")
	var neighbours = area.get_overlapping_areas()
	for n in neighbours:
		var arrow = n.find_parent("*Arrow*")
		if arrow != null and !visited.has(arrow):
			visited.append(arrow)
			visited = arrow.get_contiguous_neighbours(visited)
			
	return visited


func tick():
	if (hit and !inv) or (inv and !hit):
		emit()
	self.hit = false


func emit():
	var d = dot.instance()
	d.direction = Vector2.RIGHT.rotated(transform.get_rotation())
	d.position = position
	d.from_arrows = get_contiguous_neighbours()
	get_tree().get_root().add_child(d) 
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		emit_signal("arrow_clicked", self)

func invert():
	self.inv = !inv
	
func save():
	var data = {}
	data["name"] = self.name
	data["inv"] = self.inv
	data["hit"] = self.hit
	data["transform"] = self.transform
	return data
	
func load(data):
	self.name = data["name"]
	self.inv = data["inv"]
	self.hit = data["hit"]
	self.transform = data["transform"]
	