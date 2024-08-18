extends Node


enum CursorState {
	to_move,
	moving,
	idle,
	selecting,
	select
}
var CursorStateString = {
	CursorState.to_move: "to_move",
	CursorState.moving: "moving",
	CursorState.idle: "idle",
	CursorState.selecting: "selecting",
	CursorState.select: "select"
}

enum Tools {
	to_move,
	putting,
	selecting
}

var current_cursor: CursorState = CursorState.idle
var current_tool: Tools = Tools.selecting
func ChangeTool(tool: Tools):
	if current_tool != tool:
		current_tool = tool
		CursorToTool()

func CursorToTool():
	if current_tool == Tools.to_move:
		current_cursor = CursorState.to_move
	elif current_tool == Tools.putting:
		current_cursor = CursorState.select
	elif current_tool == Tools.selecting:
		current_cursor = CursorState.selecting
	else:
		current_cursor = CursorState.idle
	ChangeCursor()

func ChangeCursor():
	var cursor = load("res://Assets/cursor/" + CursorStateString[current_cursor] + ".png")
	if cursor:
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(6, 6))
	else:
		push_error("cannot load cursor")
		Input.set_custom_mouse_cursor(null)

var is_paused: bool = true
var hour: float = 7.0
var day_count: int = 0
