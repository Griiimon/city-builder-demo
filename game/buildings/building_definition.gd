class_name BuildingDefinition
extends Resource


@export var name: String
@export var tile_set_source: int
@export var tile_set_coords: Vector2i
@export var placement_conditions: Array[BaseBuildingPlacementCondition]



func can_build_at(tile: Vector2i, world: World)-> bool:
	for condition in placement_conditions:
		if not condition.evaluate(tile, world):
			return false
	return true
