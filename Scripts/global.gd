extends Node

# ---- CURSOR ----
enum CursorState {
	to_move,
	moving,
	idle,
	selecting,
	select,
	plowing,
	watering_can,
}
enum Tools {
	to_move,
	putting,
	selecting,
	hoe,
	watering_can
}
var tool_to_cursor_map = {
	Tools.to_move: CursorState.to_move,
	Tools.putting: CursorState.select,
	Tools.selecting: CursorState.selecting,
	Tools.hoe: CursorState.plowing,
	Tools.watering_can: CursorState.watering_can,
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

# ---- FIELD ----
class Seed:
	var name: String
	var texture: Texture2D
	
	func _init(name: String, texture: Texture2D):
		self.name = name
		self.texture = texture
var coords_label: Label
var sun_ratio: float
var seed_tool: Button
var current_seed: Seed
func set_seed(seed: Seed):
	current_seed = seed

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
