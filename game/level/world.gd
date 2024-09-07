class_name World
extends Node2D

enum Terrain { GRASS, DIRT, WATER }

@onready var terrain_layer: TileMapLayer = $Terrain
@onready var buildings_layer: TileMapLayer = $Buildings
@onready var ghosts_layer: TileMapLayer = $Ghosts

var prev_ghost_tile: Vector2i



func get_terrain_at(tile: Vector2i)-> Terrain:
	# Quick and dirty solution. In a more complex game you want
	# to have a TerrainDefinition Resource like with the Buildings
	return terrain_layer.get_cell_atlas_coords(tile).x


func has_building_at(tile: Vector2i)-> bool:
	return tile in buildings_layer.get_used_cells()


func get_building_at(tile: Vector2i)-> BuildingDefinition:
	return GameData.atlas_coords_to_building[buildings_layer.get_cell_atlas_coords(tile)]


func has_building_in_radius(building: BuildingDefinition, center: Vector2i, radius: int)-> bool:
	for x in range(-radius, radius + 1): 
		for y in range(-radius, radius + 1): 
			var tile: Vector2i= Vector2i(x, y) + center
			if not is_in_bounds(tile): continue
			if has_building_at(tile) and get_building_at(tile) == building:
				return true
	return false


func place_building(building: BuildingDefinition, tile: Vector2i):
	buildings_layer.set_cell(tile, building.tile_set_source, building.tile_set_coords)


func remove_building_at(tile: Vector2i):
	buildings_layer.erase_cell(tile)


func set_ghost(building: BuildingDefinition, tile: Vector2i):
	ghosts_layer.erase_cell(prev_ghost_tile)
	
	if not building: return
	
	prev_ghost_tile= tile
	ghosts_layer.set_cell(tile, building.tile_set_source, building.tile_set_coords)


func get_tile(position: Vector2)-> Vector2i:
	return terrain_layer.local_to_map(position)


func is_in_bounds(tile: Vector2i)-> bool:
	return tile in terrain_layer.get_used_cells()


static func get_terrain_name(terrain: Terrain)-> String:
	return Terrain.keys()[terrain].capitalize()
