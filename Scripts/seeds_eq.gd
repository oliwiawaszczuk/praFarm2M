extends Control

var Grid: GridContainer
var Slot: Texture2D
var Padlock: Texture2D

var Seeds: Array[Global.Seed] = []

func _ready():
	Slot = load("res://Assets/slot.png") as Texture2D
	Padlock = load("res://Assets/padlock.png") as Texture2D
	
	Grid = $GridContainer
	Grid.columns = 9
	
	var dir = DirAccess.open("res://Assets/seeds")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "" and file_name.ends_with(".png"):
			create_seed_packing_slot(file_name)
			file_name = dir.get_next()
	Global.set_seed(Seeds[0])

func create_seed_packing_slot(file_name: String):
	var plant_texture: Texture2D = load("res://Assets/seeds/" + file_name) as Texture2D
	var plant_name: String = get_file_name(file_name)
	var button = Button.new()
	button.icon = plant_texture
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	#button.text = plant_name
	button.name = plant_name
	button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.pressed.connect(self._on_button_pressed.bind(button))
	if button.icon != null:
		Grid.add_child(button)
		Seeds.append(Global.Seed.new(plant_name, plant_texture, get_atlas_coord_y(file_name), file_name))

func _on_button_pressed(button: Button):
	var seed: Global.Seed = find_seed_by_name(button.name)
	ScenesMenager.GoToResumeGame()
	Global.ChangeTool(Global.Tools.seeding)
	Global.ChangeCursor("res://Assets/seeds/" + seed.file_name)
	ScenesMenager.Seeds_eq.visible = false

func get_file_name(file_name: String) -> String:
	var int_name = file_name.split(".")[0]
	var name = int_name.split("_")[1]
	return name

func get_atlas_coord_y(file_name: String) -> int:
	var int_name = file_name.split(".")[0]
	var _int: int = int(int_name.split("_")[0])
	return _int

func find_seed_by_name(name: String):
	for seed in Seeds:
		if seed.name == name:
			return seed
	return null
