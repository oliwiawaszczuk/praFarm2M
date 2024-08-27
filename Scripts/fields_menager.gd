extends Node

enum FIELD_STATE {
	EMPTY,
	WATERED,
	GROWING,
	GROWNED
}

class Field:
	var position: Vector2i
	var time_of_growing: float = 0.0
	var state_of_growing: FIELD_STATE = FIELD_STATE.EMPTY
	var speed_of_growing: float = 1.0
	var hydration_level: float = 0
	var what_is_planted_atlas_coord_y: int = -1
	
	func to_dict():
		return {
			"pos_x": self.position.x,
			"pos_y": self.position.y,
			"time_of_growing": self.time_of_growing,
			"state_of_growing": FIELD_STATE.keys()[self.state_of_growing],
			"speed_of_growing": self.speed_of_growing,
			"hydration_level": self.hydration_level,
			"what_is_planted_atlas_coord_y": self.what_is_planted_atlas_coord_y,
		}
	
	func from_dict(data):
		self.position = Vector2i(data["pos_x"], data["pos_y"])
		self.time_of_growing = data["time_of_growing"]
		self.state_of_growing = FIELD_STATE[data["state_of_growing"]]
		self.speed_of_growing = data["speed_of_growing"]
		self.hydration_level = data["hydration_level"]
		self.what_is_planted_atlas_coord_y = data["what_is_planted_atlas_coord_y"]
		
		return self

var fields: Array[Field]

func add_new_field(position: Vector2i):
	var field: Field = Field.new() as Field
	field.position = position
	fields.append(field)

func load_field_data():
	for field: Field in fields:
		Global.terrain_tilemap.set_cell(Global.PLANT_LAYER, field.position, 1, Vector2i(0, field.what_is_planted_atlas_coord_y))

func Remove_field_if_exist(tile_pos: Vector2i):
	for field: Field in fields:
		if field.position == tile_pos:
			#print("Removed field: ", field.to_dict())
			Global.terrain_tilemap.set_cell(Global.PLANT_LAYER, tile_pos, -1)
			fields.erase(field)
			return field
	return null

func Seed_field(tile_pos: Vector2i, what_is_planted_atlas_coord_y: int):
	for field: Field in fields:
		if field.position == tile_pos:
			Global.terrain_tilemap.set_cell(Global.PLANT_LAYER, tile_pos, 1, Vector2i(0, Global.current_seed.atlas_coord_y))
			field.what_is_planted_atlas_coord_y = what_is_planted_atlas_coord_y
			field.state_of_growing = FIELD_STATE.GROWING

# mechanika calego pola
# podlewanie
# sadzenie
# rosniecie
# zbieranie
# zbanie

func _process(delta: float) -> void:
	if !Global.is_paused:
		for field: Field in fields:
			if field.state_of_growing == FIELD_STATE.GROWING:
				field.time_of_growing += delta * field.speed_of_growing * field.hydration_level
				print("Field: ", field.time_of_growing)
