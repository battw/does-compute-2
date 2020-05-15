extends Area2D

export var size = Vector2(3000, 3000)
export var grid_size = 50
export var cross_scale = 1
export var background_color = Color(.16, .16, .16)
export var marker_color = Color(.5, .5, .5)
var main

var Cross = preload("res://Cross.tscn")

func exited(area2d):
	var d = area2d.find_parent("*Dot*")
	if d != null:
		d.queue_free()


func _ready():
#	_add_crosses()
	self.main = find_parent("Main")
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = self.size / 2
	$CollisionShape2D.position = self.size / 2
	_create_background()


func _create_background():
	var image = Image.new()
	image.create(self.grid_size, self.grid_size, false, Image.FORMAT_RGB8)
	image.fill(self.background_color)
	image.lock()

	image.set_pixel(0, 0, Color(1, 1, 1))
	image.set_pixel(0, self.grid_size - 1 , Color(1, 1, 1))
	image.set_pixel(self.grid_size - 1, 0, Color(1, 1, 1))
	image.set_pixel(self.grid_size - 1, self.grid_size - 1 , Color(1, 1, 1))
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

func snap_to_grid(position):
	var scaled_grid = grid_size  * self.global_scale
	var x = round(position[0] / scaled_grid[0]) * scaled_grid[0]
	var y = round(position[1] / scaled_grid[1]) * scaled_grid[1]
	var maxX = self.size.x
	var maxY = self.size.y
	if x < 0:
		x = 0
	if x > maxX:
		x = maxX
	if y < 0:
		y = 0
	if y > maxY:
		y = maxY
	return Vector2(x, y)

func add_arrow(pos):
	return $Arrows.add_arrow(snap_to_grid(pos))
