class_name EnemyPath
extends Path2D

@onready var path_follow:PathFollow2D = $PathFollow
@onready var line:Line2D = $Line
@onready var enemy:Area2D = $PathFollow/Enemy

const SPEED:int = 1300

func _process(delta:float) -> void:
	path_follow.progress += SPEED * delta
	if path_follow.get_progress_ratio() == 1:
		queue_free()

func set_for_player_position(player_position:Vector2) -> void:
	var y_coords:Array = [-20,2020] # Un poco más que la altura del mapa
	for y:int in y_coords:
		var point:Vector2 = Vector2(point_slope_equation(y, player_position),y)
		curve.add_point(point)
		line.add_point(point)

func point_slope_equation(y:int, point:Vector2, m:int=1) -> float:
	return (y - point.y)/m + point.x
