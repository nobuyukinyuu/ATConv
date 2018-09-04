extends TextureRect

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed == true:
		var idx = int(name)
		
		global.chunk[idx] = global.HoldTile
		owner.get_node("Panel12/Tex").loadSubtileImgs(global.chunk)
		owner.refresh()