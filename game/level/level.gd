class_name Level
extends Node2D

enum State { DEFAULT, CONSTRUCTING }

@onready var world: World = $World
@onready var ui: LevelUI = $UI

var state: State
var current_building: BuildingDefinition

var mouse_tile_pos: Vector2i= Vector2i.ZERO:
	set(pos):
		if pos != mouse_tile_pos:
			mouse_tile_pos= pos
			update_mouse()



func _ready() -> void:
	update_mouse()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_construction"):
		state= State.CONSTRUCTING if state == State.DEFAULT else State.DEFAULT
		match state:
			State.DEFAULT:
				world.set_ghost(null, Vector2i.ZERO)
			State.CONSTRUCTING:
				if not current_building:
					current_building= GameData.buildings[0]
				update_mouse()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_tile_pos= world.get_tile(get_global_mouse_position())
	
	elif event is InputEventMouseButton:
		if not event.pressed: return
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if not state == State.CONSTRUCTING: return
				if current_building.can_build_at(mouse_tile_pos, world):
					world.place_building(current_building, mouse_tile_pos)
					update_mouse()
			
			MOUSE_BUTTON_RIGHT:
				if not state == State.DEFAULT: return
				if world.has_building_at(mouse_tile_pos):
					world.remove_building_at(mouse_tile_pos)
					update_mouse()
	
	elif event is InputEventKey:
		var building_index: int= event.keycode - KEY_1
		if building_index >= 0 and building_index <= GameData.buildings.size():
			current_building= GameData.buildings[building_index]
			update_mouse()


func update_mouse():
	match state:
		State.DEFAULT:
			if world.has_building_at(mouse_tile_pos):
				ui.set_building_name(world.get_building_at(mouse_tile_pos).name)
			else:
				ui.set_building_name()
		State.CONSTRUCTING:
			ui.set_building_name(current_building.name)
			ui.set_placement_warning()

			if not world.has_building_at(mouse_tile_pos):
				world.set_ghost(current_building, mouse_tile_pos)

				# Dont care about the result, but it will trigger placement warnings
				# so it will update in the UI when the mouse is moved
				current_building.can_build_at(mouse_tile_pos, world)
			else:
				SignalManager.building_placement_warning.emit("Tile occupied")
	
