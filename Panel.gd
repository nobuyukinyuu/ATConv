extends Panel

func _ready():
	
	for y in range(4):
		for x in range(12):
			var i = y * 12 + x
			var tex = AtlasTexture.new()
			var btn = Button.new()
			
			tex.atlas = preload("res://template47.png")
			tex.region = Rect2(x*48, y*48, 48, 48)
			
			btn.name = str(i)
			btn.rect_size = Vector2(64,64)
			btn.rect_position = Vector2(x*64, y*64)
			btn.icon = tex
			btn.set_meta("tile", i)
			btn.set_meta("chunk", [-1,-1,-1,-1])
			btn.connect("pressed", self, "btnPress", [btn])
			self.add_child(btn)
			btn.owner = owner

	global.chunk = get_node("36").get_meta("chunk").duplicate()
	global.CurrentTile = 36
	owner.get_node("PreviewPanel/Preview").texture = get_node("36").icon

#On 47 subtile button press
func btnPress(btn):
	owner.get_node("PreviewPanel/Preview").texture = btn.icon
	owner.get_node("lblTile").text = "Tile " + String(btn.get_meta("tile"))
	owner.get_node("icon").texture = btn.icon

	global.CurrentTile = btn.get_meta("tile")
	global.chunk = btn.get_meta("chunk").duplicate()
	
	owner.refresh()
	
	var grid = owner.get_node("PreviewPanel/Preview/Grid")
	for item in grid.get_children():
		if item is TextureRect:  item.texture = null
	
	
	owner.get_node("Panel12/Tex").loadSubtileImgs(global.chunk)

