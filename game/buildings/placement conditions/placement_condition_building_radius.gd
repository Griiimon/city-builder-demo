class_name PlacementConditionBuildingRadius
extends BaseBuildingPlacementCondition

@export var required_building: BuildingDefinition
@export var max_distance: int= 1



func evaluate(tile: Vector2i, world: World)-> bool:
	if not world.has_building_in_radius(required_building, tile, max_distance):
		SignalManager.building_placement_warning.emit("Requires %s within %d tiles" % [required_building.name, max_distance])
		return false
	return true
