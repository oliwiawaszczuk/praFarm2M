extends Node2D

class Hexagon:
	var position: Vector2
	var atlas_coords: Vector2

	func to_dict():
		return {
			"position": {"x": position.x, "y": position.y},
			"atlas_coords": {"x": atlas_coords.x, "y": atlas_coords.y}
		}

var TILEMAP_TERRAIN_FILE_NAME = "terrain_save"
var GLOBAL_VARIABLES_FILE_NAME = "global"
var FIELDS_FILE_NAME = "fields"

func _ready():
	if has_node("../Terrain"):
		Global.terrain_tilemap = $"../Terrain"
		load_game_components()
	#save_data_to_file(GetTerrainData(), TILEMAP_TERRAIN_FILE_NAME)
	#if terrain_tilemap != null:
		#load_game_components()
	

# FILE 
func save_data_to_file(data, file_name: String):
	var file = FileAccess.open("res://Data/" + file_name + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

func read_data_from_file(file_name: String):
	var file = FileAccess.open("res://Data/" + file_name + ".json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	var data = JSON.parse_string(json_string)
	return data

func save_game_components():
	print("saving")
	var data_to_save = {
		"day_count": Global.day_count,
		"current_time": Global.current_time,
		"money": Global.money,
	}
	save_data_to_file(data_to_save, GLOBAL_VARIABLES_FILE_NAME)
	save_data_to_file(GetTerrainData(), TILEMAP_TERRAIN_FILE_NAME)
	save_data_to_file(GetFieldData(), FIELDS_FILE_NAME)

func load_game_components():
	load_terrain()
	load_global_variables()
	load_fields_data()

func GetTerrainData():
	var hex_data = []
	var cells = Global.terrain_tilemap.get_used_cells(0)
	for cell in cells:
		var hexagon = Hexagon.new()
		var atlas_coords = Global.terrain_tilemap.get_cell_atlas_coords(0, cell)
		hexagon.position = cell
		hexagon.atlas_coords = atlas_coords
		hex_data.append(hexagon.to_dict())
	
	return hex_data

func GetFieldData():
	var fields_data = []
	for field in FieldsMenager.fields:
		fields_data.append(field.to_dict())
	return fields_data

func load_terrain():
	var data = read_data_from_file(TILEMAP_TERRAIN_FILE_NAME)
	var hex_array = []
	
	if typeof(data) == TYPE_ARRAY:
		for hex_dict in data:
			var position_dict = hex_dict["position"]
			var atlas_coords_dict = hex_dict["atlas_coords"]
			
			var hex = Hexagon.new()
			hex.position = Vector2(position_dict["x"], position_dict["y"])
			hex.atlas_coords = Vector2(atlas_coords_dict["x"], atlas_coords_dict["y"])
			hex_array.append(hex)
		
		Global.terrain_tilemap.clear()
		for hex in hex_array:
			Global.terrain_tilemap.set_cell(0, hex.position, 0, hex.atlas_coords, 0)
	else:
		print("Unexpected error in read file")

func load_global_variables():
	var data = read_data_from_file(GLOBAL_VARIABLES_FILE_NAME)
	if typeof(data) == TYPE_DICTIONARY:
		Global.day_count = data["day_count"]
		Global.current_time = data["current_time"]
		Global.money = data["money"]
	else:
		print("Unexpected error in read file")

func load_fields_data():
	var data = read_data_from_file(FIELDS_FILE_NAME)
	var fields_data = []
	if typeof(data) == TYPE_ARRAY:
		for field_data in data:
			print("loaded: ", field_data)
			FieldsMenager.fields.append(FieldsMenager.Field.new().from_dict(field_data))
