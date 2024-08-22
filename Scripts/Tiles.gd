extends Node


#enum Tile {
	#GRASS = 1,
	#WATER = 2
#}
#
#func get_tile_name_by_id(id):
	#for name in Tile:
		#if Tile[name] == id:
			#return name
	#return null
#
#enum LAYER {
	#Terrain = 0,
	#Pot = 1,
	#Ground = 2
#}
#
#var TILE_INFO = {
	#LAYER["Terrain"]: 
	#{
		#1: "GRASS",
		#2: "WATER"
	#},
	#LAYER["Pot"]: 
	#{
		#1: "BASE POT",
		#2: "BETTER POT"
	#},
	#LAYER["Ground"]: 
	#{
		#1: "CLASSIC GROUND",
	#}
#}

#func get_tile_name_by_layer_and_id(layer_id: int, tile_id: int) -> String:
	#return TILE_INFO[layer_id][tile_id]
