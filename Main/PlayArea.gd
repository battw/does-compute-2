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
	if self.snap_grid_size <= 0:
		return
		
	var extents = $CollisionShape2D.shape.extents
	
	var rows = int(2 * extents.y / self.snap_grid_size) + 1
	var cols = int(2 * extents.x / self.snap_grid_size) + 1
	for r in range(rows):
		for c in range(cols):
			var cross = Cross.instance()
			cross.scale = Vector2.ONE * cross_scale
			cross.position = Vector2(c * self.snap_grid_size, r * self.snap_grid_size)
			self.add_child(cross)	

func _out_of_bounds(local_pos):
	var half_grid = self.snap_grid_size / 2
	var play_size = 2 * $CollisionShape2D.shape.extents
	return local_pos.x > play_size.x + half_grid or local_pos.y > play_size.y + half_grid or \
		local_pos.x < -half_grid or local_pos.y < -half_grid
	

func add_arrow(pos):
	var local_pos = self.to_local(pos)
	if self._out_of_bounds(local_pos):
		return
	return $Arrows.add_arrow(local_pos, self.snap_grid_size)
	
	