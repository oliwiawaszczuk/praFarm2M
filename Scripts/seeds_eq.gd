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
		while file_name != "":
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
	
	Seeds.append(Global.Seed.new(plant_name, plant_texture))

func _on_button_pressed(button: Button):
	var seed = find_seed_by_name(button.name)
	ScenesMenager.GoToResumeGame()
	Global.ChangeTool(Global.Tools.selecting)
	Global.ChangeCursor("res://Assets/seeds/" + button.name + ".png")
	ScenesMenager.Seeds_eq.visible = false

func get_file_name(file_name: String) -> String:
	#var file_name_with_extension = file_name.get_file()
	var name = file_name.split(".")[0]
	return name

func find_seed_by_name(name: String):
	for seed in Seeds:
		if seed.name == name:
			return seed
	return null
