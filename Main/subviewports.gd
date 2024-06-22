extends Control

@export var max_separation:float = 20.0
@export var split_line_thickness:float = 3.0
@export var split_line_color:Color = Color.BLACK
@export var adaptive_split_line_thickness:bool = true

@onready var main_viewport:SubViewport = $Container1/Viewport1
@onready var secondary_viewport:SubViewport = $Container2/Viewport2
@onready var main:Node2D = $Container1/Viewport1/Level
@onready var player1:Area2D = main.get_node("Player1")
@onready var player2:Area2D = main.get_node("Player2")
@onready var view:TextureRect = $View
@onready var camera1:Camera2D = $Container1/Viewport1/Camera1
@onready var camera2:Camera2D = $Container2/Viewport2/Camera2

var view_shader : ShaderMaterial
var separation_distance:float = 0

func _ready() -> void:
	secondary_viewport.world_2d = main_viewport.world_2d
	view_shader = view.get_material()
	_on_size_changed()
	update_splitscreen()
	get_viewport().connect("size_changed", Callable(self, "_on_size_changed"))
	view_shader.set_shader_parameter("viewport1", main_viewport.get_texture())
	view_shader.set_shader_parameter("viewport2", secondary_viewport.get_texture())

func _process(_delta:float) -> void:
	separation_distance = get_distance_between_players()
	move_cameras()
	update_splitscreen()

func move_cameras() -> void:
	var position_difference:Vector2 = player2.position - player1.position
	var distance:float = clamp(separation_distance, 0, max_separation)
	
	position_difference = position_difference.normalized() * distance
	camera1.position = player1.position + position_difference / 2.0
	camera2.position = player2.position - position_difference / 2.0

func update_splitscreen() -> void:
	var player1_position:Vector2 = (player1.position - camera1.position) / (camera1.zoom * Global.viewport_size) + Vector2(0.5, 0.5)
	var player2_position:Vector2 = (player2.position - camera2.position) / (camera2.zoom * Global.viewport_size) + Vector2(0.5, 0.5)

	var thickness:float
	if adaptive_split_line_thickness:
		thickness = lerp(0.0, split_line_thickness, (separation_distance - max_separation) / max_separation)
		if thickness > 0:
			thickness = clamp(thickness, 1, split_line_thickness)
	else:
		thickness = split_line_thickness

	view_shader.set_shader_parameter("split_active", get_split_state())
	view_shader.set_shader_parameter("player1_position", player1_position)
	view_shader.set_shader_parameter("player2_position", player2_position)
	view_shader.set_shader_parameter("split_line_thickness", thickness)
	view_shader.set_shader_parameter("split_line_color", split_line_color)

func get_split_state() -> bool:
	return separation_distance > max_separation

func get_distance_between_players() -> float:
	return (player2.position - player1.position).length()

func _on_size_changed() -> void:
	main_viewport.size = Global.viewport_size
	secondary_viewport.size = Global.viewport_size
	view_shader.set_shader_parameter("viewport_size", Global.viewport_size)
