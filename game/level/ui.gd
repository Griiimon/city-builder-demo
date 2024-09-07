class_name LevelUI
extends CanvasLayer



func _ready() -> void:
	SignalManager.building_placement_warning.connect(set_placement_warning)


func set_building_name(s: String= ""):
	%"Label Building".text= s


func set_placement_warning(s: String= ""):
	%"Label Placement".text= s
