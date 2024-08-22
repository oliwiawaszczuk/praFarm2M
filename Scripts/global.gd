extends Node


enum CursorState {
	to_move,
	moving,
	idle,
	selecting,
	select,
	plowing,
}
var CursorStateString = {
	CursorState.to_move: "to_move",
	CursorState.moving: "moving",
	CursorState.idle: "idle",
	CursorState.selecting: "selecting",
	CursorState.select: "select",
	CursorState.plowing: "plowing"
}

enum Tools {
	to_move,
	putting,
	plowing,
	selecting,
	hoe,
	watering_can
}

var tool_to_cursor_map = {
	Tools.to_move: CursorState.to_move,
	Tools.putting: CursorState.select,
	Tools.selecting: CursorState.selecting,
	Tools.plowing: CursorState.plowing,
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

func ChangeCursor():
	var cursor = load("res://Assets/cursor/" + CursorStateString[current_cursor] + ".png")
	if cursor:
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(6, 6))
	else:
		push_error("cannot load cursor")
		Input.set_custom_mouse_cursor(null)

enum FIELD_STATE{
	EMPTY,
	
}

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
