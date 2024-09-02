extends Node

# ---- TERRAIN ----
var PREV_LAYER: int = 4
var PLANT_LAYER: int = 3

# ---- CURSOR ----
enum CursorState {
	to_move,
	moving,
	idle,
	selecting,
	select,
	plowing,
	watering_can,
	basket,
	shovel
}
enum Tools {
	to_move,
	placing,
	selecting,
	hoe,
	watering_can,
	basket,
	shovel,
	seeding
}
var tool_to_cursor_map = {
	Tools.to_move: CursorState.to_move,
	Tools.placing: CursorState.select,
	Tools.selecting: CursorState.selecting,
	Tools.hoe: CursorState.plowing,
	Tools.watering_can: CursorState.watering_can,
	Tools.basket: CursorState.basket,
	Tools.shovel: CursorState.shovel,
}
var current_cursor: CursorState = CursorState.selecting
var current_tool: Tools = Tools.selecting
func ChangeTool(tool: Tools):
	if current_tool != tool:
		current_tool = tool
		CursorToTool()
func CursorToTool():
	var try_cursor = tool_to_cursor_map.get(current_tool, null)
	if try_cursor == null:
		Input.set_custom_mouse_cursor(null)
		print("jeszcze nie ma cursora dla tool: ", str(Tools.keys()[current_tool]))
	else:
		current_cursor = try_cursor
		ChangeCursor()
	
	terrain_tilemap.clear_layer(Global.PREV_LAYER)
	
func ChangeCursor(custon_path = null):
	var cursor = ''
	if custon_path:
		cursor = load(custon_path)
	else:
		cursor = load("res://Assets/cursor/" + str(CursorState.keys()[current_cursor]) + ".png")
	
	if cursor:
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(6, 6))
	else:
		push_error("cannot load cursor")
		Input.set_custom_mouse_cursor(null)

func ChangeCursorBySprite(sprite):
	Input.set_custom_mouse_cursor(sprite, Input.CURSOR_ARROW, Vector2(6, 6))

# ---- FIELD ----
var plants: Array[PlantData] = []
var seed_eq_count: Dictionary = {}

func add_to_seed_eq_by_seed_name(name: String, count: int):
	var seed = find_seed_by_name(name)
	seed_eq_count[seed] += count

func return_seed_eq_as_string():
	var text: String = ""
	for seed in seed_eq_count:
		text += str(seed.name) + " - " + str(seed_eq_count[seed]) + "\n"
	return text

func return_seed_eq_as_dict():
	var dict = {}
	for seed in seed_eq_count:
		dict[seed.name] = str(seed_eq_count[seed])
	return dict

func load_dict_to_seed_eq(data):
	var names = []
	for key in seed_eq_count.keys():
		names.append(key.name)
	for name in data:
		if name in names:
			var seed = find_seed_by_name(name)
			seed_eq_count[seed] = int(data[name])

var coords_label: Label
var sun_ratio: float
var seed_tool: Button
var current_seed: PlantData
func set_seed(seed):
	current_seed = seed

func find_seed_by_name(name: String):
	for seed in plants:
		if seed.name == name:
			return seed
	return null

# ---- GAME ----
var game_area: bool = false
var is_paused: bool = false
var day_count: int = 0
@export var current_time: float = 7.0
@export var terrain_tilemap: TileMap

var camera_position: Vector2 = Vector2(0, 0)

enum time_of_day_state {
	MIDDAY,
	MIDNIGHT,
	SUNRISE,
	SUNSET
}
var current_time_of_day: time_of_day_state

var money: int = 0
var money_label: Label
func add_money(number: int):
	money += number
	money_label.text = str(money)

var cost: Dictionary = {
	"hexagon": 10,
}

var sell: Dictionary = {
	"hexagon": 8,
}

func try_remove_money_int(value: int) -> bool:
	if money - value < 0:
		return false
	else:
		money -= value
		money_label.text = str(money)
		return true

func try_remove_money_name(name: String) -> bool:
	return try_remove_money_int(cost[name])
