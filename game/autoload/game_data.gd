extends Node


@export var buildings: Array[BuildingDefinition]

# lookup table
var atlas_coords_to_building: Dictionary


func _ready() -> void:
	for building in buildings:
		atlas_coords_to_building[building.tile_set_coords]= building
