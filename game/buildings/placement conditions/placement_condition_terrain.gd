class_name PlacementConditionTerrain
extends BaseBuildingPlacementCondition

@export var terrain_whitelist: Array[World.Terrain]
@export var terrain_blacklist: Array[World.Terrain]



func evaluate(tile: Vector2i, world: World)-> bool:
	var terrain: World.Terrain= world.get_terrain_at(tile)
	
	if not terrain_whitelist.is_empty() and not terrain in terrain_whitelist:
		SignalManager.building_placement_warning.emit("Cannot build on " + World.get_terrain_name(terrain))
		return false
	
	if not terrain_blacklist.is_empty() and terrain in terrain_blacklist:
		SignalManager.building_placement_warning.emit("Cannot build on " + World.get_terrain_name(terrain))
		return false
	
	return true
