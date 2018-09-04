extends Button

func _ready():
	$FileDialog.add_filter ("*.png ; Portable Network Graphics")
	if name == "btnLoad":
		$FileDialog.add_filter ("*.bmp ; Bitmap")
		$FileDialog.add_filter ("*.tga ; TARGA")
		$FileDialog.add_filter ("*.svg ; Scalable Vector Graphics")
		$FileDialog.add_filter ("*.jpg ; JPEG (lossy)")
		$FileDialog.add_filter ("*.webp ; WebPic (lossy)")

func _on_btnLoad_pressed():
	$FileDialog.popup_centered()

func _on_btnSave_pressed():
	$FileDialog.popup_centered()



################### LOAD ###################
func _on_LoadDialog_file_selected(path):
	var obj = load(path)  #StreamTexture

	if obj == null or not obj is StreamTexture:
		owner.get_node("dlgCrapInput").popup_centered()
		return
	
	var tex = owner.get_node("Panel12/Tex").texture
	if tex is StreamTexture:  
		tex = null
		yield(get_tree(),"idle_frame")
		yield(get_tree(),"idle_frame")
	owner.get_node("Panel12/Tex").texture = obj


################### SAVE ###################
func _on_SaveDialog_file_selected(path):
	#Regen texture.
	owner._on_btnAutofill_pressed()

	var img = owner.get_node("Viewport/Overlay").texture.get_data()
	var err = img.save_png(path)
	
	prints("Save successful?", err)