extends Area2D

export var size = Vector2(3000, 3000)
export var cross_scale = 1
export var background_color = Color(.16, .16, .16)
export var marker_color = Color(.5, .5, .5)
var main

var Cross = preload("res://Cross.tscn")

func exited(area2d):
	var d = area2d.find_parent("*Dot*")
	if d != null:
		DotFactory.recycle(d)
	
	
func _ready():
#	_add_crosses()
	self.main = find_parent("Main")
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = self.size / 2
	$CollisionShape2D.position = self.size / 2
	_create_background()
	
func _add_crosses():
	if main.grid_size <= 0:
		return
		
	
	
	var rows = int(self.size.y / self.snap_grid_size) + 1
	var cols = int(self.size.x / self.snap_grid_size) + 1
	for r in range(rows):
		for c in range(cols):
			var cross = Cross.instance()
			cross.scale = Vector2.ONE * cross_scale
			cross.position = Vector2(c * main.grid_size, r * main.grid_size)
			self.add_child(cross)	
			

func _create_background():
	var image = Image.new()
	image.create(main.grid_size, main.grid_size, false, Image.FORMAT_RGB8)
	image.fill(self.background_color)
	image.lock()
	
	image.set_pixel(0, 0, Color(1, 1, 1))
	image.set_pixel(0, main.grid_size - 1 , Color(1, 1, 1))
	image.set_pixel(main.grid_size - 1, 0, Color(1, 1, 1))
	image.set_pixel(main.grid_size - 1, main.grid_size - 1 , Color(1, 1, 1))
#		image.set_pixel(12, i , Color(1, 1, 1))

	#image.fill(Color(1,1,1))
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$Background.texture = texture
	$Background.region_rect.size = self.size
	
	

func _out_of_bounds(local_pos):
	var half_grid = main.grid_size / 2
	return local_pos.x > self.size.x + half_grid or local_pos.y > self.size.y + half_grid or \
		local_pos.x < -half_grid or local_pos.y < -half_grid
	

func add_arrow(pos):
	var local_pos = self.to_local(pos)
	if self._out_of_bounds(local_pos):
		return
	return $Arrows.add_arrow(local_pos)
	
