extends Node


class Quest:
	var name: String
	var count: int
	var type: Plants.Plant
	
	func _init(name: String, count: int, type: Plants.Plant) -> void:
		self.name = name
		self.count = count
		self.type = type
	

var List = {
	1: Quest.new("Collect Carrots", 10, Plants.Plant.Carrot),
	2: Quest.new("Harvest Corn", 5, Plants.Plant.Corn),
	3: Quest.new("seeds", 2, Plants.Plant.Seed),
	4: Quest.new("more seeds", 6, Plants.Plant.Seed)
}
