extends Sprite

var yes = true
func _process(delta):
	if yes:
		print(self.texture)
	yes = false


func create(background_size, grid_size, dot_color, background_color):
	var image = Image.new()
	image.create(grid_size, grid_size, false, Image.FORMAT_RGB8)
	image.fill(background_color)
	image.lock()

	image.set_pixel(0, 0, dot_color)
	image.set_pixel(0, grid_size - 1 , dot_color)
	image.set_pixel(grid_size - 1, 0, dot_color)
	image.set_pixel(grid_size - 1, grid_size - 1 , dot_color)

	image.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(image)
	self.texture = tex
	self.region_rect.size = background_size
#	print(self.)
