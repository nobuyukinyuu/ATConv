extends Line2D
var pts = [Vector2(0,128),Vector2(256,128),Vector2(128,128), Vector2(128,0),Vector2(128,256)]

func _ready():
	points = pts
	update()