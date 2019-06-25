extends Area2D

export var snap_grid_size = 50
export var cross_scale = 1

var Cross = preload("res://Cross.tscn")

func exited(area2d):
	var d = area2d.find_parent("*Dot*")
	if d != null:
		d.queue_free()
	
func _ready():
	_add_crosses()
	
func _add_crosses():
	var extents = $CollisionShape2D.shape.extents
	if !extents:
		print("Can't get PlayArea extents")
		return
	
	var rows = int(2 * extents.y / self.snap_grid_size) + 1
	var cols = int(2 * extents.x / self.snap_grid_size) + 1
	for r in range(rows):
		for c in range(cols):
			var cross = Cross.instance()
			cross.scale = Vector2.ONE * cross_scale
			cross.position = Vector2(c * self.snap_grid_size, r * self.snap_grid_size)
			self.add_child(cross)	

func add_arrow(pos):
	return $Arrows.add_arrow(pos, self.snap_grid_size)
	
	