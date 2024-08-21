extends Node2D

var SCROLL_MAX: int = 4.2
var SCROLL_MIN: int = 1
var SCROLL_SPEED: float = 0.05
var MOUSE_MOVE_RATIO: float = 1.2
var start: Vector2 = Vector2()
var is_pressed: bool = false

var camera: Camera2D
var coords_label: Label
@export var terrain_tilemap: TileMap

func _ready():
	Global.ChangeCursor()
	camera = get_node("MainCamera")
	camera.position = Global.camera_position
	coords_label = $MainCamera/CanvasLayer/HBoxContainer/Coords
	terrain_tilemap = $Terrain

func _input(event):
	KeyDetect(event)
	if !Global.is_paused:
		MouseMove(event)
		ScreenTouch(event)
		if Global.current_tool == Global.Tools.selecting:
			Detect_tile(event)

func _process(_delta):
	if is_pressed:
		MoveScreen()

func MoveScreen():
	var mouse_pos = get_viewport().get_mouse_position()
	var delta_pos = mouse_pos - start
	camera.position -= delta_pos / camera.zoom * MOUSE_MOVE_RATIO
	Global.camera_position = camera.position
	start = mouse_pos

func MouseMove(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				start = event.position
				Global.current_cursor = Global.CursorState.moving
				Global.ChangeCursor()
				is_pressed = true
			else:
				Global.CursorToTool()
				is_pressed = false
		if Global.current_tool == Global.Tools.to_move:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					start = event.position
					Global.current_cursor = Global.CursorState.moving
					Global.ChangeCursor()
					is_pressed = true
				else:
					Global.CursorToTool()
					is_pressed = false

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			Scroll(SCROLL_SPEED)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			Scroll(-SCROLL_SPEED)

func Scroll(index):
	var cam_x = camera.zoom.x + index
	var cam_y = camera.zoom.y + index
	
	cam_x = clamp(cam_x, SCROLL_MIN, SCROLL_MAX)
	cam_y = clamp(cam_y, SCROLL_MIN, SCROLL_MAX)
	
	camera.zoom.x = cam_x
	camera.zoom.y = cam_y

func ScreenTouch(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			print("Dotknięto: ", event.position)

func Detect_tile(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: # podwojne wywolanie?
			var tile_pos = terrain_tilemap.local_to_map(terrain_tilemap.get_local_mouse_position())
			coords_label.text = get_tile_data_by_tile_pos(tile_pos)

func get_tile_data_by_tile_pos(tile_pos) -> String:
	var data: String = "(" + str(tile_pos.x) + "," + str(tile_pos.y) + ")"
	for i in range(3):
		var tile_data = terrain_tilemap.get_cell_tile_data(i, tile_pos)
		if tile_data:
			var tile_name = Tiles.get_tile_name_by_layer_and_id(i, tile_data.probability)
			if tile_name != null:
				data += " - " + tile_name
	
	return data

func KeyDetect(event):
	if event is InputEventKey and !event.is_pressed():
		if !Global.is_paused:
			if event.keycode == KEY_SPACE:
				Global.ChangeTool(Global.Tools.to_move)
			if event.keycode == KEY_1: # keycode to change
				Global.ChangeTool(Global.Tools.selecting)
			if event.keycode == KEY_2: # keycode to change
				Global.ChangeTool(Global.Tools.putting)
		if event.keycode == KEY_S:
			Save.save_game_components()


func _on_to_move_pressed() -> void:
	Global.ChangeTool(Global.Tools.to_move)


func _on_selecting_pressed() -> void:
	Global.ChangeTool(Global.Tools.selecting)
