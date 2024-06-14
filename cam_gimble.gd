extends Node3D

@export var rotation_speed =  2
@export var max_zoom = 3.0
@export var min_zoom = 0.5
@export var zoom_speed = 0.09

@onready var player: CharacterBody3D = $"../Player"


var zoom = 1.5
@onready var inner_gimble: Node3D = $InnerGimble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam_follow()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cam_follow()
	cam_rotation(delta)
	cam_zoom()





#camera_movement	
func cam_rotation(delta):
	inner_gimble.rotation.x = clamp(inner_gimble.rotation.x, deg_to_rad(-90), deg_to_rad(0))
	#rotate outer gimbal around y axis
	var y_rotation = 0
	if Input.is_action_pressed("cam_right"):
		y_rotation += 1
	if Input.is_action_pressed("cam_left"):
		y_rotation -= 1
	rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
		#rotate inner gimbal x-axis
	var x_rotation = 0
	if Input.is_action_pressed("cam_up"):
		x_rotation -= 1
	if Input.is_action_pressed("cam_down"):
		x_rotation += 1
	inner_gimble.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)
	#inner_gimble.rotate_object_local(Vector3(0, player.global_rotation.y, 0), x_rotation * rotation_speed * delta)
#camera_zoom
func cam_zoom():
	if Input.is_action_pressed("cam_zoom_in"):
		zoom -= zoom_speed
	if Input.is_action_pressed("cam_zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)
	scale = Vector3.ONE * zoom
	

func cam_follow():
	global_position = Vector3(player.global_position.x, position.y, player.global_position.z + 1)
