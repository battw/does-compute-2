extends Node2D

onready var dot = preload("res://Dot/Dot.tscn")
var inv = false setget set_inv, get_inv
var hit = false # the Arrow has been hit by a Dot since the last tick
var other_color = Color(0,0,0) # swaps between this and the main color when arrows are inverted.


func get_inv():
	return inv

func set_inv(abool):
	if abool != inv:
		inv = abool
		var poly = find_node("Polygon2D", true, false)
		poly.invert_color()

func _ready():
	add_to_group("Arrows")
	add_to_group("Tickers")
	#add_to_group("Savers")
	
	
func _enter_tree():
	pass
	
	
func hit(area2d):
	""" Called by signal from the arrows Area2d """
	var d = area2d.find_parent("*Dot*")
	if d != null and !d.from_arrows.has(self.name):
		var names = get_contiguous_neighbours_names()
		for name in names:
			var node = get_parent().get_node(name)
			node.hit = true
		d.queue_free()

# TODO: return nodes instead of names so we don't need to rely on all arrows sharing the same parent
func get_contiguous_neighbours_names(visited=[self.name]):
	""" returns an array of the names of all arrows which form a contiguous area which includes this arrow.
	An argument shouldn't be given, it is used for recursive calls by this function. """
	var area = find_node("*Area2D*")
	var neighbours = area.get_overlapping_areas()
	for n in neighbours:
		var arrow = n.find_parent("*Arrow*")
		if arrow != null and !visited.has(arrow.name):
			visited.append(arrow.name)
			visited = arrow.get_contiguous_neighbours_names(visited)
			
	return visited


func tick():
	if (hit and !inv) or (inv and !hit):
		emit()
	self.hit = false


func emit():
	var d = dot.instance()
	d.direction = Vector2.RIGHT.rotated(transform.get_rotation())
	d.position = position
	d.from_arrows = get_contiguous_neighbours_names()
	var dots = get_tree().get_root().find_node("Dots", true, false)
	if !dots:
		print("there should be a node called Dots. unable to emit dot")
		return
	dots.add_child(d)
	

func invert():
	self.inv = !inv
	
func delete():
	self.get_parent().remove_child(self)
	self.queue_free()
	
func save():
	var data = {}
	data["type"] = "Arrow"
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
	