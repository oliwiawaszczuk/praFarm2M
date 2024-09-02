extends Control

var Grid: GridContainer
var Slot: Texture2D
var Padlock: Texture2D

func _ready():
	Slot = load("res://Assets/slot.png") as Texture2D
	Padlock = load("res://Assets/padlock.png") as Texture2D
	
	Grid = $GridContainer
	Grid.columns = 9
	
	for plant in Global.plants:
		create_seed_packing_slot(plant)

func create_seed_packing_slot(plant: PlantData):
	var button = Button.new()
	button.icon = plant.seed_sprite
	button.flat = true
	button.focus_mode = Control.FOCUS_NONE
	button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	#button.text = plant_name
	button.name = plant.name
	button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.pressed.connect(self._on_button_pressed.bind(button))
	if button.icon != null:
		Grid.add_child(button)

func _on_button_pressed(button: Button):
	var seed: PlantData = Global.find_seed_by_name(button.name)
	ScenesMenager.GoToResumeGame()
	Global.ChangeTool(Global.Tools.seeding)
	Global.set_seed(seed)
	Global.ChangeCursorBySprite(seed.seed_sprite)
	ScenesMenager.Seeds_eq.visible = false
