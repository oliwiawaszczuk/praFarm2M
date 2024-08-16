extends Node2D

class Hexagon:
	var position: Vector2
	var material_id: int

@export var terrain_tilemap: TileMap


func _ready():
	terrain_tilemap = $"../Terrain"
	#save_data_to_file()


func _process(delta):
	pass


#func save_data_to_file():
	#var used_rect = terrain_tilemap.get_used_rect()
	#
	#var hex_data = []
	#
	#for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
		#for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
			#var tile_pos = Vector2(x, y)
			#var tile_data = terrain_tilemap.get_cell_tile_data(0, tile_pos)
			#
			#var hexagon = Hexagon.new()
			#hexagon.position = tile_pos
			#hexagon.material_id = tile_data.probability
			#hex_data.append(hexagon)
	#
	#var file = File.new()
	#var error = file.open("res://Data/data.json", File.WRITE)
	#if error == OK:
		#file.store_string(JSON.print(hex_data))
		#file.close()
	#else:
		#print("Failed to open file!")
		
