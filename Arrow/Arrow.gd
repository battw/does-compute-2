extends Node2D

onready var dot = preload("res://Dot/Dot.tscn")
# All the variables are exported as that means self.duplicate() 
# will maintain their current state.
export var inv = false setget set_inv, get_inv 
export var hit = false # the Arrow has been hit by a Dot since the last tick
export var color = Color(.92, .86, .7)
export var inv_color = Color(.4, .36, .33)


func get_inv():
	return inv


func set_inv(abool):
	inv = abool
	if inv:
		$Polygon2D.color = self.inv_color
	else:
		$Polygon2D.color = self.color


func _ready():
	add_to_group("Arrows")
	add_to_group("Tickers")
	self.name = "Arrow[" + str(get_instance_id()) + "]"
	#add_to_group("Savers")
	
	
func _enter_tree():
	pass
	
	
func hit(area2d):
	""" Called by signal from the arrows Area2d """
	var d = area2d.find_parent("*Dot*")
	if d != null and !d.from_arrows.has(self.name):
		var names = get_contiguous_neighbours_names()
		for name in names:
			var node = find_parent("Arrows").find_node(name, true, false)
			if node == null:
				print("Can't find arrow " + str(name) + " (Arrow.hit())")
				continue
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
	d.direction = Vector2.RIGHT.rotated(get_global_transform().get_rotation())
	d.position = global_position
	d.from_arrows = get_contiguous_neighbours_names()
	var dots = get_tree().get_root().find_node("Dots", true, false)
	if !dots:
		print("can't find Dots. Unable to emit dot (Arrow.emit())")
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
	