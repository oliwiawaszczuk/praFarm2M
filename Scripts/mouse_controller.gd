extends Node2D

var SCROLL_MAX: int = 4.2
var SCROLL_MIN: int = 1
var MOUSE_MOVE_RATIO: float = 1.2
var start: Vector2 = Vector2()
var is_pressed: bool = false

var camera: Camera2D
var coords_label: Label
@export var terrain_tilemap: TileMap

func _ready():
	camera = get_node("MainCamera")
	coords_label = $MainCamera/CanvasLayer/HBoxContainer/Coords
	terrain_tilemap = $Terrain

func _input(event):
	MouseMove(event)
	ScreenTouch(event)
	Detect_tile(event)

func _process(_delta):
	if is_pressed:
		var mouse_pos = get_viewport().get_mouse_position()
		var delta_pos = mouse_pos - start
		camera.position -= delta_pos / camera.zoom * MOUSE_MOVE_RATIO
		start = mouse_pos

func MouseMove(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				start = event.position
				is_pressed = true
			else:
				is_pressed = false

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			Scroll(0.05)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			Scroll(-0.05)

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
