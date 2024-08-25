extends Node

class Field:
	var position: Vector2i
	var time_of_growing: float = 0.0
	var state_of_growing: FIELD_STATE = FIELD_STATE.EMPTY
	var speed_of_growing: float = 1.0
	
	func to_dict():
		return {
			"pos_x": self.position.x,
			"pos_y": self.position.y,
			"time_of_growing": self.time_of_growing,
			"state_of_growing": FIELD_STATE.keys()[self.state_of_growing],
			"speed_of_growing": self.speed_of_growing,
		}
	
	func from_dict(data):
		self.position = Vector2i(data["pos_x"], data["pos_y"])
		self.time_of_growing = data["time_of_growing"]
		self.state_of_growing = FIELD_STATE[data["state_of_growing"]]
		self.speed_of_growing = data["speed_of_growing"]
		
		return self

enum FIELD_STATE{
	EMPTY,
	PLOWED,
	WATERED,
	GROWING
}

var fields: Array[Field]

func add_new_field(position: Vector2i):
	var field: Field = Field.new() as Field
	field.position = position
	fields.append(field)

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
				field.time_of_growing += delta / 100 * field.speed_of_growing
