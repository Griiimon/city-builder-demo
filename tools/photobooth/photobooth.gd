extends Node3D

@export var model: PackedScene
@export var pan_speed: float= 1
@export var bg_color: Color= Color.DEEP_PINK
@export var save_model_settings: bool= false

@onready var canvas_layer = $CanvasLayer

var obj: Node3D
var just_rotated:= false
var file_name: String
var path: String
var data_file_path: String



func _ready():
	RenderingServer.set_default_clear_color(bg_color)

	if model:
		obj= model.instantiate()
		add_child(obj)
		obj.set_process(false)
		obj.set_physics_process(false)

		var arr= model.resource_path.rsplit("/", true, 1)
		path= arr[0]
		file_name= arr[1]
		file_name= file_name.replace(".tscn", "")

		if save_model_settings:
			data_file_path= path + "/photobooth.dat"
			if FileAccess.file_exists(data_file_path):
				var file:= FileAccess.open(data_file_path, FileAccess.READ)
				obj.global_transform= file.get_var()
				file.close()



func _process(delta):
	var pan= Input.get_vector("booth_left", "booth_right", "booth_down", "booth_up")
	var pan3:= Vector3(pan.x, pan.y, Input.get_axis("booth_forward", "booth_back"))
	if pan3:
		pan3*= pan_speed * delta
		if Input.is_key_pressed(KEY_SHIFT):
			pan3*= 0.25

		obj.global_position+= pan3

	var rot: Vector2= Input.get_vector("booth_rotate_up", "booth_rotate_down", "booth_rotate_left", "booth_rotate_right")
	var rot3:= Vector3(rot.x, rot.y, Input.get_axis("booth_rotate_roll_left", "booth_rotate_roll_right"))
	if rot3:
		if not just_rotated:
			var ang: float= deg_to_rad(90)
			if Input.is_key_pressed(KEY_SHIFT):
				ang*= 0.2
			obj.rotate(Vector3.RIGHT, rot3.x * ang)
			obj.rotate(Vector3.UP, rot3.y * ang)
			obj.rotate(Vector3.FORWARD, rot3.z * ang)
		just_rotated= true
	else:
		just_rotated= false

	if Input.is_action_just_pressed("ui_select"):
		save()


func save():
	canvas_layer.hide()
	await get_tree().process_frame
	
	var model_file_name= file_name.replace("_model", "")
	var image_path: String= path + "/" + model_file_name + "_texture.png"
	
	print(image_path)
	var image: Image= get_viewport().get_texture().get_image()
	for x in image.get_width():
		for y in image.get_height():
			if image.get_pixel(x, y) == bg_color:
				image.set_pixel(x, y, Color.TRANSPARENT)

	image.save_png(image_path)
	
	if save_model_settings:
		var file:= FileAccess.open(data_file_path, FileAccess.WRITE)
		file.store_var(obj.global_transform)
		file.close()

	get_tree().quit()
