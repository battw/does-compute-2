extends Node2D

export var speed = 10.0
var direction
var from_arrows # an array containing the group of arrows which spawned this dot
var is_pooled = false

func _ready():
	add_to_group("Dots")
	#add_to_group("Tickers")


func _process(delta):
	if position == null:
		return
	position += direction * speed * delta

func save():
	var data = {}
	data["type"] = "Dot"
	data["speed"] = self.speed
	data["direction"] = self.direction
	data["from_arrows"] = self.from_arrows
	data["transform"] = self.transform
	return data

func load(data):
	self.speed = data["speed"] 
	self.direction = data["direction"]
	self.from_arrows = data["from_arrows"]
	self.transform = data["transform"]