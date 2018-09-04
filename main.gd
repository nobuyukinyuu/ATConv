extends Node2D



func _on_btnClear_pressed():
	global.chunk = [-1,-1,-1,-1]
	global.CurrentSubtile = 0
	refresh()

	for item in $PreviewPanel/Preview/Grid.get_children():
		if item is TextureRect:  item.texture = null

func _on_btnSet_pressed():
	var item = $Panel.get_node(String(global.CurrentTile))
	item.set_meta("chunk", global.chunk)
	
	var lookup = generate_lookup_table()
	var img = generate_img(lookup)
	var tex = ImageTexture.new()
	
	tex.create_from_image(img)
	$Viewport/Overlay.texture = tex



func refresh():
	$lblSubtiles.text = "UL: %s\nUR: %s\nLL: %s\nLR: %s\n" % global.chunk
	
func generate_lookup_table():
	var output = []
	for item in $Panel.get_children():
		if item.has_meta("chunk"):
			output.push_back(item.get_meta("chunk"))
			
	return output
	
#Generate image based on lookup table. 47-len Array of [subtile, subtile, subtile, subtile]s
func generate_img(lookup):
	var src = $Panel12/Tex.texture.get_data()  #Image type
	var dst = Image.new()
	var subtile_size = Vector2(src.get_width() / 6, src.get_height() / 8)
	
	dst.create(src.get_width() * 4, src.get_height(), false, src.get_format())
#	prints("output size", dst.get_width(),"x", dst.get_height())
#	print(subtile_size)
	
	#Iterate through each major tile.
	for y in range(4):
		for x in range(12):
			var pos = Vector2(x,y) * subtile_size * 2
			
			#Get the appropriate lookup chunk.
			for i in range(4):
				var o = lookup[y*12 + x]
				if o[i] > -1:
					var srcRect = Rect2((int(o[i]) % 6) * subtile_size.x,
										 int(o[i] / 6) * subtile_size.y,
										subtile_size.x, subtile_size.y )
										
					var stPos = Vector2(int(i)%2, int(i)/2) * subtile_size
					dst.blit_rect(src, srcRect, pos + stPos)
			
	return dst



func _on_btnOutputAutofill_pressed():
	var lookup = generate_lookup_table()
	print(lookup)
	pass # replace with function body


func _on_btnAutofill_pressed():
	var i = 0
	for item in $Panel.get_children():
		item.set_meta("chunk", global.twelveTo47[i])
		i+=1

	
	var img = generate_img(global.twelveTo47)
	var tex = ImageTexture.new()
	
	tex.create_from_image(img)
	$Viewport/Overlay.texture = tex

	
	global.chunk = $Panel.get_node(String(global.CurrentTile)).get_meta("chunk").duplicate()
	refresh()


