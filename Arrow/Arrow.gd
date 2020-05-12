extends Node2D

onready var Dot = preload("res://Dot/Dot.tscn")
# All the variables are exported as that means self.duplicate()
# will maintain their current state.
export var inv = false setget set_inv, get_inv
export var color = Color(.92, .86, .7)
export var inv_color = Color(.4, .36, .33)

enum { ONESTEP, TWOSTEP }
var mode = TWOSTEP # ONESTEP is unstable
var hit = false # the Arrow has been hit by a Dot since the last tick
var prev_hit = false # was hit before the last tick
var emitting = false
var dots

func get_inv():
	return inv


func set_inv(abool):
	inv = abool
	_sort_color()

func _sort_color():
	if inv:
		$Polygon2D.color = self.inv_color
	else:
		$Polygon2D.color = self.color


func _ready():
	add_to_group("Arrows")
	add_to_group("Tickers")
	self.name = "Arrow[" + str(get_instance_id()) + "]"
	self.dots = get_viewport().find_node("Dots", true, false)
	$Area2D/CollisionShape2D.shape.points = $Polygon2D.polygon



func _enter_tree():
	pass


func hit(area2d):
	""" Called by signal from the arrows Area2d """
	var d = area2d.find_parent("*Dot*")
	if d != null and !d.name == "Dots" and !d.from_arrows.has(self):
		var neighs = _get_contiguous_neighbours()
		for neigh in neighs:
			neigh.hit = true
		d.queue_free()


# TODO: return nodes instead of names so we don't need to rely on all arrows sharing the same parent
func _get_contiguous_neighbours(visited=[self]):
	""" returns an array of the names of all arrows which form a contiguous area which includes this arrow.
	An argument shouldn't be given, it is used for recursive calls by this function. """
	var neighbours = $Area2D.get_overlapping_areas()
	for n in neighbours:
		var arrow = n.find_parent("*Arrow*")
		if arrow != null and !visited.has(arrow):
			visited.append(arrow)
			visited = arrow._get_contiguous_neighbours(visited)

	return visited


var i = -1
func _process(delta):
	if i > 0:
		i -= 1
	elif i == 0:
		_sort_color()
		i -= 1


func tick():
	match self.mode:
		ONESTEP:
			self.emitting = (self.hit and !self.inv) or (!self.hit and self.inv)
		TWOSTEP:
			if (self.hit and self.prev_hit) or (!self.hit and !self.prev_hit):
				self.emitting = (self.hit and !self.inv) or (!self.hit and self.inv)

			self.prev_hit = self.hit

	if self.emitting:
		emit()

	self.hit = false


func emit():
	var d = Dot.instance()
	d.direction = Vector2.RIGHT.rotated(get_global_transform().get_rotation())
	d.global_position = self.global_position
	d.from_arrows = _get_contiguous_neighbours()
	if self.dots == null:
		print("can't find Dots. Unable to emit dot (Arrow.emit())")
		return
	self.dots.add_child(d)


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
