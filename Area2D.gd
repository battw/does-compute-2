extends Area2D


func _ready():
	self.connect("area_entered", get_parent(), "hit")