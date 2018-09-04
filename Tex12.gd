extends TextureRect

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed == true:
		global.CurrentSubtile = 0

		#Check if textures exist for the current tile
		#Start with the first chunk that isn't 0
		for i in range(3, -1, -1):
			if global.chunk[i] > -1:
				global.CurrentSubtile = i+1
				break
					

		var pos = (get_local_mouse_position() / 32).floor()
		var subtile12 = pos.y * 6 + pos.x

		if global.CurrentSubtile >3:  
			global.HoldTile = subtile12
			print("Holdtile ", global.HoldTile)
			return
		
		
		global.chunk[global.CurrentSubtile] = subtile12
		
		setImg(pos, global.CurrentSubtile)
#		print ("honkin subtile %s to %s" % [global.CurrentSubtile, pos])
#		print (global.chunk)
		
#Set a subtile in the 47-tile autotile set to a 12-tile's subtile.
func setImg(pos, bigIdx):
	var grid = owner.get_node("PreviewPanel/Preview/Grid")
	if grid.has_node(String(bigIdx)):
		var src = texture.get_data()  #Image type
		var subtile_size = Vector2(src.get_width() / 6, src.get_height() / 8)


		var tex = AtlasTexture.new()
		tex.atlas = texture
		tex.region = Rect2(pos * subtile_size, subtile_size)
		
		var sub = grid.get_node(String(bigIdx))
		sub.texture = tex

		owner.refresh()
		
	pass
	
func loadSubtileImgs(chunk):
	for i in range(len(chunk)):
		if chunk[i] < 0:  continue
		var item = owner.get_node("PreviewPanel/Preview/Grid/" + String(i))
		var pos = Vector2(int(chunk[i]) % 6, int(chunk[i]/6))
		setImg(pos, i)
