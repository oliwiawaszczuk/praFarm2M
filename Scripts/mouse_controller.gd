extends Node2D

var SCROLL_MAX: float = 4.2
var SCROLL_MIN: float = 1
var SCROLL_SPEED: float = 0.05
var MOUSE_MOVE_RATIO: float = 1.2
var start: Vector2 = Vector2()
var is_pressed: bool = false

var camera: Camera2D
@export var terrain_tilemap: TileMap

func _ready():
	Global.ChangeCursor()
	camera = get_node("MainCamera")
	camera.position = Global.camera_position
	terrain_tilemap = $Terrain

func _unhandled_input(event: InputEvent) -> void:
	KeyDetect(event)
	if ScenesMenager.current_scene == ScenesMenager.Scene.Game: #and !DisableAreas.is_busy_area(get_local_mouse_position()):
		MouseMove(event)
		ScreenTouch(event)
		
		if Global.current_tool == Global.Tools.placing:
			Adding_grass(event)
		
		if Global.current_tool == Global.Tools.shovel:
			Removing_grass(event)
		
		if Global.current_tool == Global.Tools.basket:
			Watering(event)
		
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
				Selecting_tile(event)
				if Global.current_tool == Global.Tools.hoe:
					Plow_tile()
				if Global.current_tool == Global.Tools.seeding:
					Seeding()

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

func Selecting_tile(event):
	if event is InputEventMouseButton:
		if !event.pressed:
			if Global.current_tool == Global.Tools.selecting and event.button_index == MOUSE_BUTTON_LEFT:
				Detect_tile()
			if event.button_index == MOUSE_BUTTON_RIGHT:
				Detect_tile()

func Detect_tile():
	var tile_pos = terrain_tilemap.local_to_map(terrain_tilemap.get_local_mouse_position())
	Global.coords_label.text = get_tile_data_by_tile_pos(tile_pos)

func Plow_tile():
	var tile_pos = terrain_tilemap.local_to_map(terrain_tilemap.get_local_mouse_position())
	var tile_data: TileData = terrain_tilemap.get_cell_tile_data(0, tile_pos)
	
	if tile_data:
		var can_plow = tile_data.get_custom_data("can_plow")
		if can_plow:
			terrain_tilemap.set_cell(0, tile_pos, 0, Vector2i(2, 0), 0)
			FieldsMenager.add_new_field(tile_pos)

var prev_tile: TileData
func Adding_grass(event):
	var tile_pos = terrain_tilemap.local_to_map(terrain_tilemap.get_local_mouse_position())
	if terrain_tilemap.get_cell_tile_data(0, tile_pos) == null:
		if prev_tile != terrain_tilemap.get_cell_tile_data(Global.PREV_LAYER, tile_pos) or prev_tile == null:
			terrain_tilemap.clear_layer(Global.PREV_LAYER)
			terrain_tilemap.set_cell(Global.PREV_LAYER, tile_pos, 0, Vector2(0, 0))
			prev_tile = terrain_tilemap.get_cell_tile_data(Global.PREV_LAYER, tile_pos)
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
				if Global.try_remove_money_name("hexagon"):
					terrain_tilemap.set_cell(0, tile_pos, 0, Vector2(0, 0), 0)
	else:
		terrain_tilemap.clear_layer(Global.PREV_LAYER)
		prev_tile = null
func Removing_grass(event):
	var tile_pos = terrain_tilemap.local_to_map(terrain_tilemap.get_local_mouse_position())
	if terrain_tilemap.get_cell_tile_data(0, tile_pos) != null:
		var tile_atlas_coords = terrain_tilemap.get_cell_atlas_coords(0, tile_pos)
		if prev_tile != terrain_tilemap.get_cell_tile_data(Global.PREV_LAYER, tile_pos) or prev_tile == null:
				terrain_tilemap.clear_layer(Global.PREV_LAYER)
				terrain_tilemap.set_cell(Global.PREV_LAYER, tile_pos, 0, tile_atlas_coords)
				if event is InputEventMouseButton:
					if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
						FieldsMenager.Remove_field_if_exist(tile_pos)
						terrain_tilemap.set_cell(0, tile_pos, -1)
						terrain_tilemap.clear_layer(Global.PREV_LAYER)
						prev_tile = null
	else:
		terrain_tilemap.clear_layer(Global.PREV_LAYER)
		prev_tile = null

func Seeding():
	var tile_pos = terrain_tilemap.local_to_map(terrain_tilemap.get_local_mouse_position())
	if terrain_tilemap.get_cell_tile_data(Global.PLANT_LAYER, tile_pos) == null:
		var tile_data: TileData = terrain_tilemap.get_cell_tile_data(0, tile_pos)
		if tile_data != null:
			var can_plant = tile_data.get_custom_data("can_plant")
			if can_plant:
				FieldsMenager.Seed_field(tile_pos, Global.current_seed.atlas_coord_y)

func Watering(event):
	var tile_pos = terrain_tilemap.local_to_map(terrain_tilemap.get_local_mouse_position())
	if terrain_tilemap.get_cell_tile_data(0, tile_pos) != null:
		pass # nadownienie - sprawdznie poprawne kiedy moze

func get_tile_data_by_tile_pos(tile_pos) -> String:
	var data: String = "(" + str(tile_pos.x) + "," + str(tile_pos.y) + ")"
	for i in range(3):
		var tile_data = terrain_tilemap.get_cell_tile_data(i, tile_pos)
		if tile_data:
			var tile_name = terrain_tilemap.get_cell_atlas_coords(i, tile_pos)
			if tile_name != null:
				data += " - " + str(tile_name)
	
	return data

func KeyDetect(event):
	if event is InputEventKey and !event.is_pressed():
		if !ScenesMenager.Menu.visible:
			if event.keycode == KEY_SPACE:
				Global.ChangeTool(Global.Tools.to_move)
			if event.keycode == KEY_1: # keycode to change
				Global.ChangeTool(Global.Tools.selecting)
		if event.keycode == KEY_S:
			Save.save_game_components()
		if event.keycode == KEY_P:
			ScenesMenager.TogglePause()

func _on_to_move_pressed() -> void:
	if !ScenesMenager.Menu.visible:
		Global.ChangeTool(Global.Tools.to_move)

func _on_selecting_pressed() -> void:
	if !ScenesMenager.Menu.visible:
		Global.ChangeTool(Global.Tools.selecting)

func _on_plow_pressed() -> void:
	if !ScenesMenager.Menu.visible:
		Global.ChangeTool(Global.Tools.hoe)
