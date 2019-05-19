extends Node2D

export var speed = 10.0
var direction
var arrow # the arrow which spawned this dot


func _ready():
	add_to_group("Dots")
	#add_to_group("Tickers")


func _process(delta):
	if position == null:
		return
	position += direction * speed * delta