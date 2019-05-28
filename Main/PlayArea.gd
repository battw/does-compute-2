extends Area2D

var Cross = preload("res://Cross.tscn")
export var cross_scale = 1


func exited(area2d):
	var d = area2d.find_parent("*Dot*")
	if d != null:
		d.queue_free()
	
func _ready():
	var main = get_tree().root.find_node("Main", true, false)
	if !main:
		print("Background grid can't find main")
		return
	var extents = $CollisionShape2D.shape.extents
	if !extents:
		print("Can't get PlayArea extents")
		return
	
	var rows = int(2 * extents.y / main.snap_grid_size) + 1
	var cols = int(2 * extents.x / main.snap_grid_size) + 1
	for r in range(rows):
		for c in range(cols):
			var cross = Cross.instance()
			cross.scale = Vector2.ONE * cross_scale
			cross.position = Vector2(c * main.snap_grid_size, r * main.snap_grid_size)
			
			self.add_child(cross)
			

	
	
	