extends Polygon2D

class_name Circle

export var radius = 10
export var segments = 10

func _ready():
	var vertices = PoolVector2Array()
	for seg in range(segments):
		var vertex = Vector2(0, radius).rotated(seg * (2*PI / segments))
		vertices.append(vertex)
	polygon = vertices
