tool
extends Node2D

var index = 0
export(bool) var ForceUpdate setget forceUpdate  #Forces an update_change()
export(bool) var PadZeroes
export(bool) var GenerateAllPalettes
export(Vector2) var TileSize = Vector2(16,16) setget changeTileSize
export(Vector2) var Separation = Vector2(0,0) setget changeSeparation
export(Texture) var TextureToCut = null setget changeTexture

var isEmptyCache = {}


var palpal = {
	"palette" : [[0, 0, 0], [0, 0, 0], [121, 121, 121], [162, 162, 162], [48, 81, 130], [65, 146, 195], [97, 211, 227], [162, 255, 243], [48, 97, 65], [73, 162, 105], [113, 227, 146], [162, 255, 203], [56, 109, 0], [73, 170, 16], [113, 243, 65], [162, 243, 162], [56, 105, 0], [81, 162, 0], [154, 235, 0], [203, 243, 130], [73, 89, 0], [138, 138, 0], [235, 211, 32], [255, 243, 146], [121, 65, 0], [195, 113, 0], [255, 162, 0], [255, 219, 162], [162, 48, 0], [227, 81, 0], [255, 121, 48], [255, 203, 186], [178, 16, 48], [219, 65, 97], [255, 97, 178], [255, 186, 235], [154, 32, 121], [219, 65, 195], [243, 97, 255], [227, 178, 255], [97, 16, 162], [146, 65, 243], [162, 113, 255], [195, 178, 255], [40, 0, 186], [65, 65, 255], [81, 130, 255], [162, 186, 255], [32, 0, 178], [65, 97, 251], [97, 162, 255], [146, 211, 255], [121, 121, 121], [178, 178, 178], [235, 235, 235], [255, 255, 255]],
	"subPals" : [[1, 2, 3, 55], [1, 8, 9, 10], [1, 8, 9, 54], [1, 40, 36, 42], [1, 40, 41, 42], [1, 48, 44, 45], [1, 44, 45, 46], [1, 48, 45, 50], [1, 44, 45, 6], [1, 24, 28, 29], [1, 28, 30, 31], [24, 25, 26, 27], [1, 25, 22, 23], [24, 25, 22, 23], [1, 44, 40, 35], [1, 40, 32, 35], [1, 24, 34, 23], [1, 28, 21, 23], [1, 8, 17, 18], [40, 50, 7, 54], [48, 46, 6, 54], [48, 50, 6, 7], [1, 4, 50, 54], [1, 3, 54, 55], [1, 36, 34, 39], [32, 33, 34, 35], [36, 33, 34, 35], [8, 17, 18, 19], [8, 17, 19, 55], [4, 13, 15, 55], [8, 2, 51, 54], [4, 8, 17, 51], [48, 47, 51, 54], [32, 29, 30, 23], [20, 28, 30, 26], [1, 40, 49, 42], [48, 40, 36, 41], [48, 40, 41, 37], [48, 40, 37, 41], [48, 40, 49, 42], [1, 20, 21, 23], [1, 4, 50, 7]]
}
#Actual godot-friendly palette
var palette = []
var SubpalGrad = preload('./GradientMap.tres')  #Gradient prototype.
var gradShader = preload('./GradientMap.shader')
var subpals = []


func _enter_tree():
	init_subpals()

func initPalette():
	palette.clear()
	var first_index = true
	for item in palpal["palette"]:
		var color = ColorN('white',1.0)
		color.r = item[0] / 255.0
		color.g = item[1] / 255.0
		color.b = item[2] / 255.0
		if first_index == true:  	color.a = 0.0  #First color is transparent.
		
		palette.append(color)
		first_index = false


#Add a bunch of subpal gradients to le subpals var
func init_subpals():
	initPalette()
	for subpal in palpal['subPals']:
		var gradient = SubpalGrad.duplicate(true)
		var arr = []
		for i in range(4):
			arr.append(palette[subpal[i]])
				
		gradient.gradient.colors = PoolColorArray(arr)
		subpals.append(gradient)


func forceUpdate(value):
	update_change()

func changeTileSize(value):
	TileSize = value
	
func changeSeparation(value):
	Separation = value
	
func changeTexture(value):
	TextureToCut = value
	index = 0
	if TextureToCut:
		update_change()
	else:
		for i in range(0, get_child_count()):
			get_child(i).queue_free()
	
func update_change():
	if TextureToCut == null: return 
	if not (TileSize.x > 0 and TileSize.y > 0):  return
	isEmptyCache.clear()


	var w  = TextureToCut.get_width()
	var h  = TextureToCut.get_height()
	var tx = floor(w / TileSize.x)
	var ty = floor(h / TileSize.y)
	
	var zeroes = len(str(tx*ty))
	var subpalZeroes = len(str(len(subpals)))
#	print(zeroes)
#	print(subpalZeroes)
	
	for i in range(0, get_child_count()):
		get_child(i).queue_free()
					
	
	for i in range(len(subpals)):
		var mat = ShaderMaterial.new()
		mat.shader = gradShader
		mat.set_shader_param('gradient', subpals[i])

		for y in range(ty):
			for x in range(tx):
				index = (y * tx) + x
				if not is_empty(TextureToCut,x*TileSize.x,y*TileSize.y,TileSize.x, TileSize.y, index): 
					var sprite = Sprite.new()	
					prints('add index', index, 'from',  x,',',y)
	#				index = (x + tx) * y
	
					#Old pad zero naming for non-subpal code
	#				if PadZeroes:
	#					sprite.set_name(("%0" + str(zeroes) + "d") % index)
	#				else:
	#					sprite.set_name(str(index))
	
					#Set name
					if PadZeroes:
						var spz = ("%0" + String(subpalZeroes) + "d") % i  #Subpal index
						var tilez = ("%0" + str(zeroes) + "d") % index
						sprite.set_name(spz + "_" + tilez)
					else:
						sprite.set_name("%s_%s" % [i, index])
	
					if GenerateAllPalettes:  sprite.material = mat
					sprite.texture = TextureToCut
					sprite.region_enabled = true
					sprite.region_rect = Rect2(x*TileSize.x,y*TileSize.y,TileSize.x, TileSize.y)
					sprite.position.x = (x * TileSize.x) + (x*Separation.x)
					sprite.position.y = (y * TileSize.y) + (y*Separation.y) + (i * TextureToCut.get_height())
	
	
					add_child(sprite)
					sprite.owner = get_tree().get_edited_scene_root()
		if not GenerateAllPalettes:  break
	
func _draw():
	pass
	
func is_empty(texture,x,y,w,h, cache_index=-1):
	if isEmptyCache.has(cache_index):
		return isEmptyCache[cache_index]
	
	var image  = texture.get_data()
	image.lock()
	for xx in range(x,x+w):
		for yy in range(y,y+h):
			
			var pixel = image.get_pixel(xx,yy)
			if pixel.a != 0:
				image.unlock()
				isEmptyCache[cache_index] = false
				return false 
	
	
	image.unlock()
	isEmptyCache[cache_index] = true
	return true
	
	
	
	
	