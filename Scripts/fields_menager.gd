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
	var seed_name: String = ""
	
	func reset_to_empty_field():
		time_of_growing = 0.0
		state_of_growing = FIELD_STATE.EMPTY
		speed_of_growing = max(speed_of_growing - 0.2, 1.0)
		hydration_level = max(hydration_level - 15, 0)
		what_is_planted_atlas_coord_y = -1
		seed_name = ""
	
	func to_dict():
		return {
			"pos_x": self.position.x,
			"pos_y": self.position.y,
			"time_of_growing": self.time_of_growing,
			"state_of_growing": FIELD_STATE.keys()[self.state_of_growing],
			"speed_of_growing": self.speed_of_growing,
			"hydration_level": self.hydration_level,
			"what_is_planted_atlas_coord_y": self.what_is_planted_atlas_coord_y,
			"seed_name": self.seed_name,
		}
	
	func from_dict(data):
		self.position = Vector2i(data["pos_x"], data["pos_y"])
		self.time_of_growing = data["time_of_growing"]
		self.state_of_growing = FIELD_STATE[data["state_of_growing"]]
		self.speed_of_growing = data["speed_of_growing"]
		self.hydration_level = data["hydration_level"]
		self.what_is_planted_atlas_coord_y = data["what_is_planted_atlas_coord_y"]
		self.seed_name = data["seed_name"]
		
		return self

var fields: Array[Field]

func add_new_field(position: Vector2i):
	var field: Field = Field.new() as Field
	field.position = position
	fields.append(field)

func load_field_data():
	for field: Field in fields:
		var atlas_coords_x = 0
		if field.time_of_growing >= 100:
			atlas_coords_x = int(str(field.time_of_growing)[0])
		Global.terrain_tilemap.set_cell(Global.PLANT_LAYER, field.position, 1, Vector2i(atlas_coords_x, field.what_is_planted_atlas_coord_y))

func get_field_by_pos(tile_pos: Vector2i):
	for field: Field in fields:
		if field.position == tile_pos:
			return field
	return null

func Remove_field_if_exist(tile_pos: Vector2i):
	var field = get_field_by_pos(tile_pos)
	if field:
		Global.terrain_tilemap.set_cell(Global.PLANT_LAYER, tile_pos, -1)
		fields.erase(field)
		return field
	return null

func Remove_seed_if_exist(tile_pos: Vector2i):
	var field = get_field_by_pos(tile_pos)
	if field:
		#print("Removed field: ", field.to_dict())
		Global.terrain_tilemap.set_cell(Global.PLANT_LAYER, tile_pos, -1)
		field.reset_to_empty_field()
		return field
	return null

func Seed_field(tile_pos: Vector2i, what_is_planted_atlas_coord_y: int, seed_name: String):
	var field = get_field_by_pos(tile_pos)
	if field:
		Global.terrain_tilemap.set_cell(Global.PLANT_LAYER, tile_pos, 1, Vector2i(0, Global.current_seed.atlas_coord_y))
		field.what_is_planted_atlas_coord_y = what_is_planted_atlas_coord_y
		field.state_of_growing = FIELD_STATE.GROWING
		field.seed_name = seed_name

func Hydration(tile_pos: Vector2i, value: float):
	var field = get_field_by_pos(tile_pos)
	if field:
		if field.hydration_level < 100 + value and field.hydration_level >= 0:
			field.hydration_level += value

func get_stats_of_field(tile_pos: Vector2i):
	var field = get_field_by_pos(tile_pos)
	if field:
		Global.coords_label.text = "Position: " + str(field.position) + "\b
		Field state: " + str(FIELD_STATE.keys()[field.state_of_growing]) + "\b
		Time of growing: " + str(round(field.time_of_growing)) + "\b
		What is growing: " + str(field.seed_name) + "\b
		Speed of growing: " + str(field.speed_of_growing) + "\b
		Hydration level: " + str(round(field.hydration_level)) + "\b
		"
	else: 
		Global.coords_label.text = "Position: " + str(tile_pos) + "\nno field"

func update_altlas_coords_x(field: Field):
	var atlas_coords_x = int(str(field.time_of_growing)[0])
	var tile_data = Global.terrain_tilemap.get_cell_tile_data(Global.PLANT_LAYER, field.position)

	if tile_data != null:
		var atlas_coords = Global.terrain_tilemap.get_cell_atlas_coords(Global.PLANT_LAYER, field.position)
		Global.terrain_tilemap.set_cell(Global.PLANT_LAYER, field.position, 1, atlas_coords)

func collect_file_if_can(tile_pos: Vector2):
	var field: Field = get_field_by_pos(tile_pos)
	if field and field.state_of_growing == FIELD_STATE.GROWNED:
		# dodanie do eq
		print("zebrano: ", field.seed_name)
		Global.add_to_seed_eq_by_seed_name(field.seed_name, randi_range(1, 3))
		Remove_seed_if_exist(field.position)
		get_stats_of_field(tile_pos)

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
				field.time_of_growing += delta / 100 * field.speed_of_growing * field.hydration_level
				if field.time_of_growing > 500:
					field.time_of_growing = 500
					field.state_of_growing = FIELD_STATE.GROWNED
				#print("Field: ", field.time_of_growing)
				if int(str(field.time_of_growing/100)[0]) != Global.terrain_tilemap.get_cell_atlas_coords(Global.PLANT_LAYER, field.position).x:
					field.hydration_level = max(field.hydration_level - 5, 0)
					Global.terrain_tilemap.set_cell(Global.PLANT_LAYER, field.position, 1, Vector2(int(str(field.time_of_growing)[0]), field.what_is_planted_atlas_coord_y))
