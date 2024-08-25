extends Node

var busy_areas: Array[Control] = []

func is_busy_area(mouse_position: Vector2) -> bool:
	for area in busy_areas:
		var busy_area_rect = area.get_rect()
		if busy_area_rect.has_point(mouse_position):
			#print("Sprawdzanie obszaru: ", busy_area_rect, " pozycja myszy: ", mouse_position, " - ", busy_area_rect.has_point(mouse_position))
			return true
	return false
